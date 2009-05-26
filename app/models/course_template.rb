class CourseTemplate < ActiveRecord::Base
  def self.from_xml(doc)
    new(:sourced_id => doc.sourced_id,
    :title => doc.title,
    :description => doc.optional(:description),
    :code => doc.code)
  end
  def to_xml
    "<course_template>
    <sourced_id>#{sourced_id}</sourced_id>
    <title>#{title}</title>
    #{optional_xml(:description)}
    <code>#{code}</code>
    </course_template>"
  end
end
