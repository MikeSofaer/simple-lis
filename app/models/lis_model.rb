class LISModel
  include SAXMachine
  include SAXSaver

  def self.container
    name.pluralize
  end
  
  def optional_xml(field)
    value = self.send(field)
    return unless value
    "<#{field}>#{value.is_a?(DateTime) ? value.to_s(:db) : value }</#{field}>"
  end
end

class LISContainer
  include SAXMachine
  include SAXSaver

  def self.container; nil; end
  def to_xml
"<#{table_name}> " + collection.map(&:to_xml).join("\n") + "
</#{table_name}>"
  end
end