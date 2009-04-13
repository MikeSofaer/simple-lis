class CourseTemplate < ActiveRecord::Base
  def self.from_xml(doc)
    object = find_by_sourced_id(doc.sourced_id)
    object[:update] = true if object
    object ||= new(:sourced_id => doc.sourced_id)
    object.title = doc.title
    object.description = doc.description
    object.code = doc.code
    object
  end
  def return_xml
    "<course_template>
    <sourced_id>#{sourced_id}</sourced_id>
    <title>#{title}</title>
    <description>#{description}</description>
    <code>#{code}</code>
    </course_template>"
  end
end
