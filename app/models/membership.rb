class Membership < ActiveRecord::Base
  def term=(term)
    self.term_sourced_id = term.sourced_id
  end
  def person=(person)
    self.person_sourced_id = person.sourced_id
  end
  def target=(target)
    self.target_sourced_id = target.sourced_id
    self.target_type = target.class.table_name
  end
  def self.from_xml(doc)
    new(:sourced_id => doc.sourced_id,
      :target_sourced_id => doc.target_sourced_id,
      :target_type => doc.target_type,
      :person_sourced_id => doc.person_sourced_id,
      :role => doc.role.name,
      :starts_at => doc.role.optional(:starts_at),
      :ends_at => doc.role.optional(:ends_at))
  end
  def to_xml
    "<membership>
    <sourced_id>#{sourced_id}</sourced_id>
    <person_sourced_id>#{person_sourced_id}</person_sourced_id>
    <target_sourced_id>#{target_sourced_id}</target_sourced_id>
    <target_type>#{target_type}</target_type>
    <role>
      <name>#{role}</name>
      #{optional_xml(:starts_at)}
      #{optional_xml(:ends_at)}
    </role>
    </membership>"
  end
end
