require File.dirname(__FILE__) + '/../spec_helper'

describe "Person" do
  before(:each) do
    @bob = Person.find_by_sourced_id("bobjones1")
  end

  it "should return properly formatted XML" do
    doc = Hpricot("<person>
  <sourced_id>bobjones1</sourced_id>
  <names>
    <given>Bob</given>
    <family>Jones</family>
  </names>
  <contact_info>
    <email>bobjones@your_school.edu</email>
  </contact_info>
</person>")
    out = @bob.return_xml
    Hpricot(out).to_s.should == doc.to_s
  end
end