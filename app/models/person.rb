require 'nokogiri_prettifier'
require 'sax_saver'
class Person
  include SAXMachine
  include SAXSaver
  element :sourced_id
  element :given, :as => :given_name
  element :family, :as => :family_name
  element :email

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
end

class People
  include SAXMachine
  include SAXSaver
  elements :person, :as => :people, :class => Person
  def to_xml
"<people> " + @people.map(&:to_xml).join("\n") + "
</people>"
  end

end
