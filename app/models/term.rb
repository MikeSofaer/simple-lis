class Term < LISModel
  element :sourced_id, :required => true
  element :title, :required => true
  element :starts_at, :db_type => DateTime
  element :ends_at, :db_type => DateTime
  
  def starts_at=(value)
    @starts_at = value.is_a?(DateTime) ? value : DateTime.parse(value)
  end
  
  def ends_at=(value)
    @ends_at = value.is_a?(DateTime) ? value : DateTime.parse(value)
  end

  def to_xml
    "<term>
    <sourced_id>#{sourced_id}</sourced_id>
    <title>#{title}</title>
    <starts_at>#{starts_at.to_s(:db)}</starts_at>
    <ends_at>#{ends_at.to_s(:db)}</ends_at>
    </term>"
  end
end

class Terms < LISContainer
  elements :term, :as => :terms, :class => Term
end

