class CourseSection < LISModel
  element :sourced_id, :required => true
  element :course_offering_sourced_id, :required => true
  element :label, :required => true
  element :description

  table "course_sections"
  tag :course_section
  
  def course_offering=(offering)
    self.course_offering_sourced_id = offering.sourced_id
  end
  
  def to_xml
    "<course_section>
    <sourced_id>#{sourced_id}</sourced_id>
    <course_offering_sourced_id>#{course_offering_sourced_id}</course_offering_sourced_id>
    <label>#{label}</label>
    #{optional_xml(:description)}
    </course_section>"
  end
end