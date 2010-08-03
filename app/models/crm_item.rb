# To change this template, choose Tools | Templates
# and open the template in the editor.

class CrmItem

  @attrhash = Hash.new
  
  def initialize (hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v)  ## create and initialize an instance variable for this key/value pair
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})  ## create the getter that returns the instance variable
      #self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})  ## create the setter that sets the instance variable
      @attrhash = hash
    end
  end

  def attributes
    @attrhash
  end
end
