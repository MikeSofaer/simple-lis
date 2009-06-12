class GroupsController < LisController
  def model
    Group
  end
  def resource
    "group"
  end
  def filterable_on
    [:category, :sub_category]
  end
end
