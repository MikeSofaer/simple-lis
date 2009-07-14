class LISModel
  include SAXMachine
  include SAXSaver

    def optional_xml(field)
    value = self.send(field)
    return unless value
    "<#{field}>#{value}</#{field}>"
  end
end

class LISContainer
  include SAXMachine
  include SAXSaver

  def to_xml
"<#{table_name}> " + collection.map(&:to_xml).join("\n") + "
</#{table_name}>"
  end
end