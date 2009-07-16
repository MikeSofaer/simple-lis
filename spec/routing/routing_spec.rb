require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LisController do
  describe "routes" do
    it "generates params for #index" do
      params_from(:get, '/people').should == { :action => "index", :resource => "people", :controller => "lis" }
    end
    
    it "generates params for #show" do
      params_from(:get, '/people/1').should == { :action => "show", :resource => "people", :controller => "lis", :sourced_id => "1" }
    end
    
    it "generates params for #update" do
      params_from(:put, '/people').should == { :action => "update", :resource => "people", :controller => "lis" }
    end
    
    it "generates params for #destroy" do
      params_from(:delete, '/people/1').should == { :action => "destroy", :resource => "people", :controller => "lis", :sourced_id => "1" }
    end
  end
  
  describe "nested routes" do
    it "generates params for #index" do
      params_from(:get, '/terms/1/people').should == { :action => "index", :resource => "people", :controller => "lis", :parent => 'terms', :parent_sourced_id => '1' }
    end
    
    it "generates params for #show" do
      params_from(:get, '/terms/1/people/1').should == { :action => "show", :resource => "people", :controller => "lis", :sourced_id => "1", :parent => 'terms', :parent_sourced_id => '1' }
    end
    
    it "generates params for #update" do
      params_from(:put, '/terms/1/people').should == { :action => "update", :resource => "people", :controller => "lis", :parent => 'terms', :parent_sourced_id => '1' }
    end
    
    it "generates params for #destroy" do
      params_from(:delete, '/terms/1/people/1').should == { :action => "destroy", :resource => "people", :controller => "lis", :sourced_id => "1", :parent => 'terms', :parent_sourced_id => '1' }
    end
  end
end