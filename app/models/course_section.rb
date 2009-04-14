class CourseSection < ActiveRecord::Base
  def self.from_xml(doc)
    object = find_by_sourced_id(doc.sourced_id)
    object[:update] = true if object
    object ||= new(:sourced_id => doc.sourced_id)
    object.course_offering_sourced_id = doc.course_offering_sourced_id
    object.label = doc.label
    object
  end
  def return_xml
    "<course_section>
    <sourced_id>#{sourced_id}</sourced_id>
    <course_offering_sourced_id>#{course_offering_sourced_id}</course_offering_sourced_id>
    <label>#{label}</label>#{description_tag}
    </course_section>"
  end
  private
  def description_tag
    description.blank? ? nil : "\n<description>#{description}</description>"
  end
end
