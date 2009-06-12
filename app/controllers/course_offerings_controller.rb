class CourseOfferingsController < LisController
  def model
    CourseOffering
  end
  def resource
    "course_offering"
  end
  def filterable_on
    [:course_template_sourced_id, :term_sourced_id]
  end
end
