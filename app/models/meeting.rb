class Meeting < ActiveRecord::Base
  acts_as_ical
  def target=(target)
    self.target_sourced_id = target.sourced_id
    self.target_type = target.class.table_name
  end

  def self.from_xml(doc)
    m = new(:sourced_id => doc.sourced_id,
    :target_sourced_id => doc.target_sourced_id,
    :target_type => doc.target_type)
    m.set_ical(doc.i_calendar)
    m
  end

  def to_xml
    "<meeting>
    <sourced_id>#{sourced_id}</sourced_id>
    <target_sourced_id>#{target_sourced_id}</target_sourced_id>
    <target_type>#{target_type}</target_type>
    <i_calendar>#{get_ical.to_s}</i_calendar>
    </meeting>"
  end
end
