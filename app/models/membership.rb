class Membership < ActiveRecord::Base
   def self.from_xml(doc)
    object = find_by_sourced_id(doc.sourced_id)
    object[:update] = true if object
    object ||= new(:sourced_id => doc.sourced_id)
    object.target_sourced_id = doc.target_sourced_id
    object.target_type = doc.target_type
    object.person_sourced_id = doc.person_sourced_id
    object.role = doc.role
    object
  end
  def return_xml
    "<membership>
    <sourced_id>#{sourced_id}</sourced_id>
    <person_sourced_id>#{person_sourced_id}</person_sourced_id>
    <target_sourced_id>#{target_sourced_id}</target_sourced_id>
    <target_type>#{target_type}</target_type>
    <role>#{role}</role>
    </membership>"
  end
end
