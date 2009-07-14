class Person
  include SAXMachine
  include SAXSaver
  element :sourced_id, :required => true
  element :given, :as => :given_name, :required => true
  element :family, :as => :family_name, :required => true
  element :email, :required => true

  def to_xml
"<person>
  <sourced_id>#{sourced_id}</sourced_id>
  <names>
    <given>#{given_name}</given>
    <family>#{family_name}</family>
  </names>
  <contact_info>
    <email>#{email}</email>
  </contact_info>
</person>"
  end
  
  class AR < ActiveRecord::Base
    self.table_name = self.parent_name.tableize
    
    def to_xml_with_ar
      to_xml_without_ar(:root => self.class.parent_name)
    end
    alias_method_chain :to_xml, :ar
  end
end

class People
  include SAXMachine
  include SAXSaver
  elements :person, :as => :people, :class => Person

  def to_xml
%Q{<people> #{@people.map(&:to_xml) * "\n"}
</people>}
  end
end
