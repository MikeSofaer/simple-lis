class CourseSection < ActiveRecord::Base
  def course_offering=(offering)
    self.course_offering_sourced_id = offering.sourced_id
  end
  
  def self.from_xml(doc)
    new(:sourced_id => doc.sourced_id,
    :course_offering_sourced_id => doc.course_offering_sourced_id,
    :label => doc.label,
    :description => doc.optional(:description))
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
