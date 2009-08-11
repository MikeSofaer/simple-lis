class LISModel
  include SAXualReplication

  def validate
    super
    raise InvalidForeignKeyError unless foreign_key_valid?
  end

  def save!
    raise InvalidForeignKeyError unless foreign_key_valid?
    self.class.save [self]
  end

  def optional_xml(field)
    value = self.send(field)
    return unless value
    
    "<#{field}>#{value.is_a?(DateTime) ? value.to_s(:db) : value }</#{field}>"
  end
  
  def foreign_key_valid?
    true
  end

  class InvalidForeignKeyError < Exception; end
end