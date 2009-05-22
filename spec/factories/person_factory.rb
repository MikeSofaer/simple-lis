Factory.define :person do |f|
  f.given_name "Test"
  f.family_name "User"
  f.sequence(:email) { |n| "test_#{n}@school.edu"}
  f.sourced_id { |u| "#{u.email}_sourcedId"}
end