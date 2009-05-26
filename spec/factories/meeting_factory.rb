Factory.define :meeting do |f|
  f.association :target, :factory => :course_section
  f.sequence(:sourced_id) { |n| "#{n}_meeting_sourced_id"}
  f.raw_icalendar "BEGIN:VCALENDAR
BEGIN:VEVENT
DTEND;TZID=Pacific:20040415T130000
DTSTAMP:20040319T205045Z
DTSTART;TZID=Pacific:20040415T120000
SEQUENCE:0
SUMMARY:hjold intyel
END:VEVENT
END:VCALENDAR"

end