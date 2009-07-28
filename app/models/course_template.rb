class CourseTemplate < LISModel
  element :sourced_id, :required => true
  element :title, :required => true
  element :code, :required => true
  element :description

  table "course_templates"
  tag :course_template
  key_column :sourced_id

  def to_xml
    "<course_template>
    <sourced_id>#{sourced_id}</sourced_id>
    <title>#{title}</title>
    #{optional_xml(:description)}
    <code>#{code}</code>
    </course_template>"
  end
end