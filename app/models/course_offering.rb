class CourseOffering < ActiveRecord::Base
=begin  belongs_to :term, :foreign_key => :term_sourced_id, :reference_column => 'sourced_id'
  belongs_to :course_template, :foreign_key => :course_template_sourced_id, :reference_column => 'sourced_id'
  belongs_to :group, :foreign_key => :group_sourced_id, :reference_column => 'sourced_id'
=end

  def course_template=(template)
    self.course_template_sourced_id = template.sourced_id
  end
  def term=(term)
    self.term_sourced_id = term.sourced_id
  end
  def group=(group)
    self.group_sourced_id = group.sourced_id
  end

  def self.from_xml(doc)
    new(:sourced_id => doc.sourced_id,
      :term_sourced_id => doc.term_sourced_id,
      :course_template_sourced_id => doc.course_template_sourced_id,
      :group_sourced_id => doc.optional(:group_sourced_id))
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
