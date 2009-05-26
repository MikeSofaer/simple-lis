Factory.define :person do |f|
  f.given_name "Test"
  f.family_name "User"
  f.sequence(:email) { |n| "test_#{n}@school.edu"}
  f.sequence(:sourced_id) { |u| "person_#{u}_sourcedId"}
end