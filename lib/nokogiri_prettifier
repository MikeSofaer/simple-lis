require 'nokogiri'

module Nokogiri
  class MissingFieldError < Exception #:nodoc:
  end
  class Elem
    def optional(method)
      list = send("children_of_type", method.to_s)
      child = list[0] if list.size == 1
      if child
        return child.inner_text if (child.children.size == 1 and child.children[0].class == Hpricot::Text)
        return child
      end
      if list.blank?
         return nil
      end
      return list      
    end
    def method_missing(method, *args)
      list = send("children_of_type", method.to_s)
      child = list[0] if list.size == 1
      if child
        return child.inner_text if (child.children.size == 1 and child.children[0].class == Hpricot::Text)
        return child
      end
      if list.blank?
         raise MissingFieldError, "There is no field with the name '#{method.to_s}' in \n#{self.to_s}"
      end
      return list
    end
  end
  class XML::Document
    def method_missing(method, *args)
      list = at(method)
      raise MissingFieldError, "There is no field with the name '#{method.to_s}' in \n#{self.to_s}" unless list
      return list.text if list.is_a? Nokogiri::XML::Element
      return list
    end
  end
end
class ActiveRecord::Base
  def optional_xml(field)
    value = self.send(field)
    return unless value
    "<#{field}>#{value}</#{field}>"
  end
end