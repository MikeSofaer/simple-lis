class PeopleController < LisController
  def model
    Person
  end
  def resource
    "person"
  end
  def filterable_on
    [:person_sourced_id]
  end
end
