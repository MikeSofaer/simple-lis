class Group < LISModel

  element :sourced_id, :required => true
  element :title, :required => true
  element :category, :required => true
  element :sub_category, :required => true
  element :description
  element :parent_sourced_id

  table "groups"
  tag :group
  key_column :sourced_id

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
  
  def parent=(parent)
    self.parent_sourced_id = parent.sourced_id
  end
end