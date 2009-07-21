class Membership < LISModel
  element :sourced_id, :required => true
  element :target_sourced_id, :required => true
  element :target_type, :required => true
  element :person_sourced_id, :required => true
  element :role_name, :required => true, :as => :role
  element :starts_at, :db_type => DateTime
  element :ends_at, :db_type => DateTime

  table "memberships"
  tag :membership
  
  def starts_at=(value)
    @starts_at = value.is_a?(DateTime) ? value : DateTime.parse(value)
  end
  
  def ends_at=(value)
    @ends_at = value.is_a?(DateTime) ? value : DateTime.parse(value)
  end
  
  def term=(term)
    self.term_sourced_id = term.sourced_id
  end
  
  def person=(person)
    self.person_sourced_id = person.sourced_id
  end
  
  def target=(target)
    self.target_sourced_id = target.sourced_id
    self.target_type = target.class.instance_variable_get('@table_name')
  end
  
  def to_xml
    "<membership>
    <sourced_id>#{sourced_id}</sourced_id>
    <person_sourced_id>#{person_sourced_id}</person_sourced_id>
    <target_sourced_id>#{target_sourced_id}</target_sourced_id>
    <target_type>#{target_type}</target_type>
    <role>
      <role_name>#{role}</role_name>
      #{optional_xml(:starts_at)}
      #{optional_xml(:ends_at)}
    </role>
    </membership>"
  end
end