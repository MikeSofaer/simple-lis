class CourseTemplate < LISModel
  element :sourced_id, :required => true
  element :title, :required => true
  element :code, :required => true
  element :description

  def to_xml
    "<course_template>
    <sourced_id>#{sourced_id}</sourced_id>
    <title>#{title}</title>
    #{optional_xml(:description)}
    <code>#{code}</code>
    </course_template>"
  end
end

class CourseTemplates < LISContainer
  elements :course_template, :as => :course_templates, :class => CourseTemplate
end
