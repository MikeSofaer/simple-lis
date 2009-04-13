require File.dirname(__FILE__) + '/../spec_helper'

describe Group do
  before(:each) do
    @group = Group.first
  end

  it "should return properly formatted XML" do
    doc = Hpricot("<group>
    <sourced_id>Application</sourced_id>
    <title>Inigral</title>
    <category>Enterprise</category>
    <sub_category>Enterprise</sub_category>
    </group>")
    out = @group.return_xml
    Hpricot(out).to_s.should == doc.to_s
  end
end

