class PkiController < ApplicationController
  

  def index

    # Inicializamos valores para mostrarlos en la vista

    # Valores de Oportunidades
    @margen = 0
    opportunities = get_opportunities
    opportunities.each {|opp| @margen+=opp.amount}
    @comisiones = 0
    opportunities.each {|opp| @comisiones+=opp.comision }
    @costo = 0
    opportunities.each {|opp| @costo+=opp.cost}
    @total = @margen + @costo
    @costo = @total - @comisiones - @margen

  end

  def opportunities
    if request.xhr?

      # Generamos el array de oportunidades
      opportunities = get_opportunities
      
      # Revisamos si debemos hacer sort
      params[:sidx].empty? ? opportunities :
        opportunities = opportunities.sort_by { |opp| opp.instance_variable_get("@#{params[:sidx]}") }
      
      # Revisamos si piden ordenar al veres
      if (!params[:sidx].empty? && !params[:sord].eql?("asc"))
        opportunities.reverse!
      end

      # Hacemos las páginas REVISAR
      #tmp_opp = opportunities.slice!((params[:rows].to_i*(params[:page].to_i-1))..(params[:rows].to_i*(params[:page].to_i-1)+params[:rows].to_i-1))
      
      #tmp_opp.each {|tmp| opportunities.unshift(tmp)}
      

      # Pasamos la info como Json
      render :json => opportunities.to_jqgrid_json([:id, :name, :account_name,
          :assigned_user_name, :cost, :amount,:age, :sales_stage],
        params[:page], params[:rows], opportunities.size)

    end
  end

  private
  def get_opportunities
      crm = SugarCrm.new
      params[:rows].nil? ? max_results = 1 : max_results = params[:rows]

      crm_query = {:module_name => "Opportunities",
        :query => "opportunities.sales_stage != 'Closed Won' and opportunities.sales_stage != 'Closed Lost'",
        :max_results => "1000",
        :select_fields => ["id", "name", "account_name", "assigned_user_name", "sales_stage", "date_entered"]}

      opportunities = crm.get_entry_list(crm_query)
      opp_ids = Array.new
      opportunities.each { |opp| opp_ids << "opportunity_id = '#{opp.id}'" }
      quote_query = opp_ids.join(" or ")

      crm_query = {:module_name => "Quotes",
        :query => quote_query,
        :max_results => "100",
        :select_fields => ["id","opportunity_id"]
      }

      quotes = crm.get_entry_list(crm_query)

      opportunities.each do |opp|
        quotes.each do |quote|
          if opp.id == quote.opportunity_id
            opp.quote = quote.id
          end
        end
      end

      quotes_ids = Array.new
      opportunities.each { |opp| quotes_ids << "quote_id = '#{opp.quote}'"}
      product_query = quotes_ids.join(" or ")

      crm_query = {:module_name => "ProductQuotes",
        :query => product_query,
        :max_results => "100",
      }

      products_quotes = crm.get_entry_list(crm_query)

      opportunities.each do |opp|
        products_quotes.each do |pq|
          if opp.quote == pq.quote_id
            opp.product_quotes << pq
          end
        end
      end

      opportunities.each {|opp| opp.get_amount(opp.product_quotes)}
      opportunities
  end

end
