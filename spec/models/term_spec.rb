require File.dirname(__FILE__) + '/../spec_helper'

describe Term do
  before(:each) do
    @term = Term.first
  end

  it "should return properly formatted XML" do
    doc = Hpricot("<term>
    <sourced_id>200901</sourced_id>
    <title>Winter 2009</title>
    <begins_on>2009-01-01 00:00:00 UTC</begins_on>
    <ends_on>2009-05-01 00:00:00 UTC</ends_on>
    </term>")
    out = @term.return_xml
    Hpricot(out).to_s.should == doc.to_s
  end
end

