class Group < ActiveRecord::Base
  def self.from_xml(doc)
    object = find_by_sourced_id(doc.sourced_id)
    object[:update] = true if object
    object ||= new(:sourced_id => doc.sourced_id)
    object.title = doc.title
    object.category = doc.category
    object.sub_category = doc.sub_category
    object
  end
  def return_xml
    "<group>
    <sourced_id>#{sourced_id}</sourced_id>
    <title>#{title}</title>
    <category>#{category}</category>
    <sub_category>#{sub_category}</sub_category>
    </group>"
  end
end
