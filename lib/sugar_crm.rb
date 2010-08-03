# To change this template, choose Tools | Templates
# and open the template in the editor.

require "soap/wsdlDriver"
require "digest/md5"

class SugarCrm

  attr_reader :soap, :soapSession, :sid, :uid, :items

  def initialize ()
    user = "admin"
    password = "1d27ed466bd3994dd167b509c12cacf6"
    ua = {"user_name" => user, "password" => password}
    wsdl = "http://sugar.itlinux.cl/soap.php?wsdl"

    # Creamos conexión SOAP
    @soap = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
    @soapSession = @soap.login(ua,nil)
    @sid = @soapSession['id']
    @uid = @soap.get_user_id(@sid)
  end

  def get_entry_list(queryhash)
    items = []
    result = self.soap.get_entry_list(self.sid,
      queryhash[:module_name],
      queryhash[:query],
      queryhash[:order_by],
      queryhash[:offset],
      queryhash[:select_fields],
      queryhash[:max_results],
      queryhash[:deleted])

    if(result.entry_list.size >= 1)
      for entry in result.entry_list
        item = {}
        for name_value in entry.name_value_list
          item[name_value.name]=name_value.value
        end
        oitem = Kernel.const_get(queryhash[:module_name].singularize).new(item)
        items << oitem
      end
      items
    elsif(result.entry_list.size < 1)
      nil
    end
  end

  def get_entry(queryhash)
    result = self.soap.get_entry(self.sid,
      queryhash[:module_name],
      queryhash[:id],
      queryhash[:select_fields]
    )
    item = {}
    for name_value in result.entry_list[0].name_value_list
      item[name_value.name]=name_value.value
    end
    oitem = Kernel.const_get(queryhash[:module_name].singularize).new(item)
    oitem
  end

end

