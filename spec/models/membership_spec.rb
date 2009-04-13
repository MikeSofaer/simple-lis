require File.dirname(__FILE__) + '/../spec_helper'

describe Membership do
  before(:each) do
    @membership = Membership.first
  end

  it "should return properly formatted XML" do
    doc = Hpricot("<membership>
    <sourced_id>1</sourced_id>
    <person_sourced_id>bobjones1</person_sourced_id>
    <target_sourced_id>Math</target_sourced_id>
    <target_type>Group</target_type>
    <role>Faculty</role>
    </membership>")
    out = @membership.return_xml
    Hpricot(out).to_s.should == doc.to_s
  end
end

