class Meeting < ActiveRecord::Base
  acts_as_ical

  def self.from_xml(doc)
    object = find_by_sourced_id(doc.sourced_id)
    object[:update] = true if object
    object ||= new(:sourced_id => doc.sourced_id)
    object.target_sourced_id = doc.target_sourced_id
    object.target_type = doc.target_type
    object.set_ical(doc.i_calendar)
    object
  end

  def return_xml
    "<meeting>
    <sourced_id>#{sourced_id}</sourced_id>
    <target_sourced_id>#{target_sourced_id}</target_sourced_id>
    <target_type>#{target_type}</target_type>
    <i_calendar>#{get_ical.to_s}</i_calendar>
    </meeting>"
  end
end
