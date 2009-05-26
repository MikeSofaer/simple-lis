class Term < ActiveRecord::Base
  def self.from_xml(doc)
    new(:sourced_id => doc.sourced_id,
      :title => doc.title,
      :starts_at => doc.optional(:starts_at),
      :ends_at => doc.optional(:ends_at))
  end
  def to_xml
    "<term>
    <sourced_id>#{sourced_id}</sourced_id>
    <title>#{title}</title>
    <starts_at>#{starts_at}</starts_at>
    <ends_at>#{ends_at}</ends_at>
    </term>"
  end
end
