class LISModel
  include SAXMachine
  include SAXSaver
  
end

class LISContainer
  include SAXMachine
  include SAXSaver

  def to_xml
"<#{table_name}> " + collection.map(&:to_xml).join("\n") + "
</#{table_name}>"
  end
end