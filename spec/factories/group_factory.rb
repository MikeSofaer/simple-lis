Factory.define :group do |f|
  f.title "Moonbase"
  f.category "AcademicUmbrella"
  f.sub_category "Campus"
  f.description "Main campus on the moon"
  f.sequence(:sourced_id) { |n| "#{n}_group_sourced_id"}
end

Factory.define :school, :parent => :group do |f|
  f.title "Moon school"
  f.category "AcademicUmbrella"
  f.sub_category "School"
  f.description "It's a school on the goddamn moon!"
  f.association :parent, :factory => :group
end