class Term < LISModel

  element :sourced_id, :required => true
  element :title, :required => true
  element :starts_at
  element :ends_at
  
  def to_xml
    "<term>
    <sourced_id>#{sourced_id}</sourced_id>
    <title>#{title}</title>
    <starts_at>#{starts_at.strftime("%Y-%m-%d %H:%M:%S")}</starts_at>
    <ends_at>#{ends_at.strftime("%Y-%m-%d %H:%M:%S")}</ends_at>
    </term>"
  end
end

class Terms < LISContainer
  elements :term, :as => :terms, :class => Term
end

