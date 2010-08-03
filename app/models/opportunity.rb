# To change this template, choose Tools | Templates
# and open the template in the editor.


class Opportunity

  attr_reader :hash, :quote, :cost, :amount, :age, :product_quotes, :product_margin, :comision

  def initialize (hash)
    @cost, @amount, @age, @comision = 0, 0, 0, 0
    @hash = hash
    @product_quotes = []
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v)  ## create and initialize an instance variable for this key/value pair
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})  ## create the getter that returns the instance variable
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})  ## create the setter that sets the instance variable
    end
    self.get_age

    @product_margin = {"Licencias Zimbra" => 0.30,
      "Hardware" => 0.1,
      "HH" => 1,
      "HH Inhabil" => 1,
      "Licencias Endian" => 0.2,
      "Licencias Hyperic" => 0.2,
      "Licencias Mailcleaner" => 0.3,
      "Licencias Red Hat" => 0.15,
    }
  end

  def cost=(new_cost)
    @cost = new_cost
  end

  def amount=(new_amount)
    @amount = new_amount
  end

  def age=(new_age)
    @age = new_age
  end

  def quote=(new_quote)
    @quote = new_quote
  end

  def comision=(new_comision)
    @comision = new_comision
  end

  def attributes
    @hash
  end


  def get_age
    old_date = Time.new
    old_date = self.date_entered.to_time
    @age = ((old_date - Time.now).abs.round)/3600/24
  end

  def get_amount (products)
    for product in products
      if self.product_margin["#{product.product_name}"].nil?
        self.amount += product.product_total_price.to_i
      else
        self.amount += product.product_total_price.to_i * self.product_margin["#{product.product_name}"]
        self.cost += product.product_total_price.to_i * (1 - self.product_margin["#{product.product_name}"])
      end
    end

    if self.assigned_user_name.eql?("mcaceres")
      self.comision = (self.amount + self.cost) * 0.1
      self.amount -= self.comision
      self.cost += self.comision
    end

  end
  
  def get_quote
    # crm = SugarCrm.new
    crm_query = {:module_name => "Quotes",
      :query => "opportunity_id = '#{self.id}'",
      :max_results => 1,
      :select_fields => "id"}
    quote = $CRM.get_entry_list(crm_query)
    quote.nil? ? nil : @quote = quote.id
    #@quote = quote.id
  end

  def get_products
    #crm = SugarCrm.new
    crm_query = {:module_name => "ProductQuotes",
      :query => "quote_id = '#{self.quote}'",
      :max_results => 1000}
    products = $CRM.get_entry_list(crm_query)
  end

end
