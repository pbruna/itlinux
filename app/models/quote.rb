# To change this template, choose Tools | Templates
# and open the template in the editor.

class Quote
  attr_reader

  def initialize (hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v)  ## create and initialize an instance variable for this key/value pair
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})  ## create the getter that returns the instance variable
      #self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})  ## create the setter that sets the instance variable
    end
  end

  #def attributes
   # @hash
  #end
#  attr_reader :items
#
#  def initialize (opportunity_id)
#    @items = []
#    crm = SugarCrm.new()
#
#    crm_query = {:module_name => "Quotes",
#      :query => "opportunity_id = '#{opportunity_id}'",
#      :max_results => 100
#    }
#
#    @items = crm.get_entry_list(crm_query)
#
#  end
end
