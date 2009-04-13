class Term < ActiveRecord::Base
  def self.from_xml(doc)
    object = find_by_sourced_id(doc.sourced_id)
    object[:update] = true if object
    object ||= new(:sourced_id => doc.sourced_id)
    object.title = doc.title
    object.begins_on = Date.parse(doc.begins_on)
    object.ends_on = Date.parse(doc.ends_on)
    object
  end
  def return_xml
    "<term>
    <sourced_id>#{sourced_id}</sourced_id>
    <title>#{title}</title>
    <begins_on>#{begins_on}</begins_on>
    <ends_on>#{ends_on}</ends_on>
    </term>"
  end
end
