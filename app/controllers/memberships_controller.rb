class MembershipsController < LisController
  def model
    Membership
  end
  def resource
    "membership"
  end
  def filterable_on
    [:person_sourced_id]
  end
end
