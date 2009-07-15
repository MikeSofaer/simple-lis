require File.dirname(__FILE__) + '/../spec_helper'
describe PeopleController do
  describe "get requests" do
    before(:each) do
      Factory(:person, :sourced_id => "bobjones1")
    end
    
    it "should have built the person" do
      Person.datamapper_class.all.size.should == 1
    end
    
    it "should return a list of people on index" do
      get :index
      doc = Hpricot(response.body)
      user = Person.parse(doc.to_s)
      user.class.should == Person
      response.status.should == "200 OK"
    end
    
    it "should return a person on show" do
      get :show, :sourced_id => "bobjones1"
      doc = Hpricot(response.body)
      user = Person.parse(doc.to_s)
      user.class.should == Person
      response.status.should == "200 OK"
    end
  end

  describe "put requests" do
    before(:each) do
      @xml = Hpricot("<people><person>
  <sourced_id>bjones8</sourced_id>
  <names>
    <given>Bob</given>
    <family>Jones</family>
  </names>
  <contact_info>
    <email>bob@your_school.edu</email>
  </contact_info>
</person></people>")
    end

    it "should fail a put with an empty person" do
      request.env['RAW_POST_DATA'] = "<person></person>"
      put :update
      response.status.should == "422 Unprocessable Entity"
    end

    it "should fail a put with no sourced_id" do
      @xml.search('sourced_id').remove
      request.env['RAW_POST_DATA'] = @xml.to_s
      put :update
      response.status.should == "422 Unprocessable Entity"
    end

    it "should succeed on a put with a duplicate email" do  #I'd change this, but it's not easy to do, due to ON DUPLICATE KEY UPDATE
      pe = People.new
      pe.people = [Factory.build(:person, :email => "bob@your_school.edu")]
      pe.save!
      
      request.env['RAW_POST_DATA'] = @xml.to_s
      go = lambda{put :update}
      go.should change(Person.datamapper_class.all, :size).by(1)
      response.status.should == "200 OK"
    end

    it "should succeed at a put with an OK person" do
      request.env['RAW_POST_DATA'] = @xml.to_s
      put :update
      response.status.should == "200 OK"
    end
  end

  describe "multi-record import" do
    it "should be able to import two people" do
      request.env['RAW_POST_DATA'] = "<people><person>
  <sourced_id>bjones8</sourced_id>
  <names>
    <given>Bob</given>
    <family>Jones</family>
  </names>
  <contact_info>
    <email>bob@your_school.edu</email>
  </contact_info>
</person>
      <person>
  <sourced_id>bjones9</sourced_id>
  <names>
    <given>Bob</given>
    <family>Jones</family>
  </names>
  <contact_info>
    <email>bob4@your_school.edu</email>
  </contact_info>
</person></people>"
      go = lambda{put :update}
      go.should change(Person.datamapper_class.all, :size).by(2)
      response.status.should == "200 OK"
    end

  end

  describe "delete requests" do
    before(:each) do
      pe = People.new
      pe.people = [@person = Factory.build(:person, :sourced_id => "bobjones1")]
      pe.save!
    end

    it "should fail with no sourced_id" do
      go = lambda{delete :delete}
      go.should raise_error ActionController::RoutingError
    end

    it "should fail with a bad sourced_id" do
      delete :delete, :sourced_id => "jim2"
      response.status.should == "404 Not Found"
    end

    it "should succeed with a good sourced_id" do
      go = lambda{delete :delete, :sourced_id => "bobjones1"}
      go.should change(Person.datamapper_class.all, :size).by(-1)
      response.status.should == "204 No Content"
    end

    it "should delete the person's memberships" do
      Factory(:membership)#, :person => @person) #it gets stuck here, so commenting this out until we fix the factories
      go = lambda{delete :delete, :sourced_id => "bobjones1"}
      go.should change(Membership, :count).by(-1)
      response.status.should == "204 No Content"
    end
  end

  describe "replication" do
        before(:each) do
      @xml = Hpricot("<people><person>
  <sourced_id>bjones8</sourced_id>
  <names>
    <given>Bob</given>
    <family>Jones</family>
  </names>
  <contact_info>
    <email>bob@your_school.edu</email>
  </contact_info>
</person></people>")
    end

    it "should provide a URL to retrive the object" do
      request.env['RAW_POST_DATA'] = @xml.to_s
      put :update
      response.body.should == "<url>http://test.host/people/bjones8</url>"
    end

    it "URL provided should return an object"
    it "object returned should correctly reproduce XML"
  end
end