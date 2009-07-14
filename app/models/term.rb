class Term
  include SAXMachine
  include SAXSaver
  element :sourced_id, :required => true
  element :title, :required => true
  element :starts_at
  element :ends_at
  
  def to_xml
    "<term>
    <sourced_id>#{sourced_id}</sourced_id>
    <title>#{title}</title>
    <starts_at>#{starts_at}</starts_at>
    <ends_at>#{ends_at}</ends_at>
    </term>"
  end
end

class Terms
  include SAXMachine
  include SAXSaver
  elements :term, :as => :terms, :class => Term
  def to_xml
"<terms> " + @terms.map(&:to_xml).join("\n") + "
</terms>"
  end
end

