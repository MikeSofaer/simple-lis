class Person < ActiveRecord::Base
  validates_uniqueness_of :email  #This is to make the exception pretty for the response
  def self.from_xml(doc)
    new(
      :sourced_id => doc.sourced_id,
      :given_name => doc.names.given,
      :family_name => doc.names.family,
      :email => doc.contact_info.email)
  end
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
