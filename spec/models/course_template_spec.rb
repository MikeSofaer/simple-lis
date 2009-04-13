require File.dirname(__FILE__) + '/../spec_helper'

describe "CourseTemplate" do
  before(:each) do
    @template = CourseTemplate.find_by_sourced_id("sample")
  end

  it "should return properly formatted XML" do
    doc = Hpricot("<course_template>
    <sourced_id>sample</sourced_id>
    <title>Sample Course</title>
    <description>A course that doesn't exist, because I made it up!</description>
    <code>FAKE101</code>
    </course_template>")
    out = @template.return_xml
    Hpricot(out).to_s.should == doc.to_s
  end
end