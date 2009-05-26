Factory.define :membership do |f|
  f.association :person
  f.association :target, :factory => :course_section
  f.role "Student"
  f.association :term
  f.starts_at Time.now
  f.ends_at Time.now + 6.months
  f.sequence(:sourced_id) { |n| "#{n}_membership_sourced_id"}
end