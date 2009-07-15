Factory.define :course_section do |f|
  f.description "Section description"
  f.label "Section label"
  f.association :course_offering
  f.sequence(:sourced_id) { |n| "section sourced_id #{n}" }
end

Factory.define :course_offering do |f|
  f.association :term
  f.association :course_template
  f.association :group
  f.sequence(:sourced_id) { |n| "offering sourced_id #{n}" }
end

Factory.define :course_template do |f|
  f.title "Title"
  f.description "Description"
  f.code "Code"
  f.sequence(:sourced_id) { |n| "#{n}_sourcedId"}
end

Factory.define :term do |f|
  f.title "Term Title"
  f.starts_at DateTime.now
  f.ends_at DateTime.now + 6.months
  f.sequence(:sourced_id) { |n| "#{n}_sourcedId"}
end