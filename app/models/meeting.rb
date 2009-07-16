class Meeting < LISModel
  element :sourced_id, :required => true
  element :target_sourced_id, :required => true
  element :target_type, :required => true
  element :raw_icalendar
  
  # acts_as_ical
  
  def target=(target)
    self.target_sourced_id = target.sourced_id
    self.target_type = target.class.container.constantize.table_name
  end
  
  def raw_icalendar=(ical)
    ical = Vpim::Icalendar.decode(ical)[0] if ical.is_a? String

    puts "in raw_icalendar setting raw_icalendar to #{ical.encode}"

    @raw_icalendar = ical.encode
  end

  def to_xml
    "<meeting>
    <sourced_id>#{sourced_id}</sourced_id>
    <target_sourced_id>#{target_sourced_id}</target_sourced_id>
    <target_type>#{target_type}</target_type>
    <i_calendar>#{Vpim::Icalendar.decode(raw_icalendar)[0].to_s}</i_calendar>
    </meeting>"
  end
end


class Meetings < LISContainer
  elements :meeting, :as => :meetings, :class => Meeting
end

