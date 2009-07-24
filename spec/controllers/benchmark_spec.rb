require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'benchmark'

describe LisController do
  it "should not take too long" do
    people = "<people>"
    30000.times {people << Factory.build(:person).to_xml}
    people << "</people>"
    request.env['RAW_POST_DATA'] = people
    t = Time.now
    go = lambda {put :update, :resource => 'people'}
    go.call
    (Time.now - t).should < 75
  end
end