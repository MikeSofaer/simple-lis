class CourseTemplatesController < LisController
  def model
    CourseTemplate
  end
  def resource
    "course_template"
  end
  def filterable_on
    []
  end
end
