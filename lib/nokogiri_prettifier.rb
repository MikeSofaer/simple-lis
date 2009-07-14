require 'nokogiri'

module Nokogiri
  class MissingFieldError < Exception #:nodoc:
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