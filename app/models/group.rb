class Group < ActiveRecord::Base
  def parent=(parent)
    self.parent_sourced_id = parent.sourced_id
  end
  def self.from_xml(doc)
    new(:sourced_id => doc.sourced_id,
      :title => doc.title,
      :category => doc.category,
      :sub_category => doc.sub_category,
      :description => doc.optional(:description),
      :parent_sourced_id => doc.optional(:parent_sourced_id))
  end
  def to_xml
    "<group>
    <sourced_id>#{sourced_id}</sourced_id>
    <title>#{title}</title>
    <category>#{category}</category>
    <sub_category>#{sub_category}</sub_category>
    #{optional_xml(:description)}
    #{optional_xml(:parent_sourced_id)}
    </group>"
  end
end
