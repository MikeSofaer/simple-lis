class LISModel
  include SAXualReplication

  def save!
    self.class.save [self]
  end

  def optional_xml(field)
    value = self.send(field)
    return unless value
    
    "<#{field}>#{value.is_a?(DateTime) ? value.to_s(:db) : value }</#{field}>"
  end
end