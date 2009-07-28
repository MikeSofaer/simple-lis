Factory.define :membership do |f|
  f.association :person
  f.association :target, :factory => :course_section
  f.role "Student"
  # f.association :term
  f.starts_at DateTime.now
  f.ends_at DateTime.now + 6.months
  f.sequence(:sourced_id) { |n| "#{n}_membership_sourced_id"}
end