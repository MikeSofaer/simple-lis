require 'hpricot'

module Hpricot
  class BadFieldError < Hpricot::Error #:nodoc:
  end
  class Elem
    def method_missing(method, *args)
      list = send("children_of_type", method.to_s)
      child = list[0] if list.size == 1
      if child
        return child.inner_text if (child.children.size == 1 and child.children[0].class == Hpricot::Text)
        return child
      end
      if list.blank?
         raise BadFieldError, "There is no field with the name '#{method.to_s}' in \n#{self.to_s}"
      end
      return list
    end
  end
  class Doc
    def method_missing(method, *args)
      list = send("children_of_type", method.to_s)
      child = list[0] if list.size == 1
      if child
        return child.inner_text if (child.children.size == 1 and child.children[0].type == Hpricot::Text)
        return child
      end
      if list.blank?
         raise BadFieldError, "There is no field with the name '#{method.to_s}' in \n#{self.to_s}"
      end
      return list
    end
  end
end