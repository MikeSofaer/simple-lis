class Meeting < LISModel
  element :sourced_id, :required => true
  element :target_sourced_id, :required => true
  element :target_type, :required => true
  element :i_calendar, :as => :raw_icalendar, :required => true

  table "meetings"
  tag :meeting
  key_column :sourced_id

  def target=(target)
    self.target_sourced_id = target.sourced_id
    self.target_type = target.class.instance_variable_get('@table_name')
  end
  
  def raw_icalendar=(ical)
    ical = Vpim::Icalendar.decode(ical)[0] if ical.is_a? String
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
  
  def foreign_key_valid?
    !Meeting.connection.query("select * from #{target_type.tableize} where sourced_id = ?", target_sourced_id).empty?
  end  
end