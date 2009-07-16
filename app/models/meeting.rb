class Meeting < LISModel
  include ActsAsIcal

  element :sourced_id, :required => true
  element :target_sourced_id, :required => true
  element :target_type, :required => true
  element :i_calendae, :as => :ical, :required => true
  
  def ical=(value)
    set_ical(value)
  end

  def target=(target)
    self.target_sourced_id = target.sourced_id
    self.target_type = target.class.table_name
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

class Meetings < LISContainer
  elements :meetings, :as => :meetings, :class => Meeting
end
