class CourseOffering < LISModel
  element :sourced_id, :required => true
  element :term_sourced_id, :required => true
  element :course_template_sourced_id, :required => true
  element :group_sourced_id

  def course_template=(template)
    self.course_template_sourced_id = template.sourced_id
  end
  
  def term=(term)
    self.term_sourced_id = term.sourced_id
  end
  
  def group=(group)
    self.group_sourced_id = group.sourced_id
  end
  
  def to_xml
    "<course_offering>
    <sourced_id>#{sourced_id}</sourced_id>
    <course_template_sourced_id>#{course_template_sourced_id}</course_template_sourced_id>
    <term_sourced_id>#{term_sourced_id}</term_sourced_id>
    #{optional_xml(:group_sourced_id)}
    </course_offering>"
  end
end

class CourseOfferings < LISContainer
  elements :course_offerings, :as => :course_offerings, :class => CourseOffering
end

