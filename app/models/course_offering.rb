class CourseOffering < ActiveRecord::Base
  def self.from_xml(doc)
    object = find_by_sourced_id(doc.sourced_id)
    object[:update] = true if object
    object ||= new(:sourced_id => doc.sourced_id)
    object.term_sourced_id = doc.term_sourced_id
    object.course_template_sourced_id = doc.course_template_sourced_id
    object
  end
  def return_xml
    "<course_offering>
    <sourced_id>#{sourced_id}</sourced_id>
    <course_template_sourced_id>#{course_template_sourced_id}</course_template_sourced_id>
    <term_sourced_id>#{term_sourced_id}</term_sourced_id>
    #{group_tag}
    </course_offering>"
  end
  private
  def group_tag
    group_sourced_id.blank? ? nil : "<group_sourced_id>#{group_sourced_id}</group_sourced_id>"
  end
end
