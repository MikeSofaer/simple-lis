class Person < ActiveRecord::Base
  validates_uniqueness_of :email  #This is to make the exception pretty for the response
  def self.from_xml(doc)
    p doc
    object = find_by_sourced_id(doc.sourced_id)
    object[:update] = true if object
    object ||= new(:sourced_id => doc.sourced_id)
    object.given_name = doc.names.given
    object.family_name = doc.names.family
    object.email = doc.contact_info.email
    object
  end
  def return_xml
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
