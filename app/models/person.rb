class Person < LISModel
  element :sourced_id, :required => true
  element :given, :as => :given_name, :required => true
  element :family, :as => :family_name, :required => true
  element :email, :required => true

  table "people"
  tag :person

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
