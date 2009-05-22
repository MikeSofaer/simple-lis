require File.dirname(__FILE__) + '/../spec_helper'
=begin
describe PeopleController do
  describe "get requests" do
    it "should return a list of people on index" do
      get :index
      doc = Hpricot(response.body)
      user = Person.from_xml(doc.people.person)
      user.class.should == Person
      response.status.should == "200 OK"
    end
    it "should return a person on show" do
      get :show, :sourced_id => "bobjones1"
      doc = Hpricot(response.body)
      user = Person.from_xml(doc.person)
      user.class.should == Person
      response.status.should == "200 OK"
    end
  end
  describe "put requests" do
    it "should fail a put with an empty person" do
      request.env['RAW_POST_DATA'] = "<person></person>"
      put :update
      response.status.should == "422 Unprocessable Entity"
    end
    it "should fail a put with an empty person" do
      request.env['RAW_POST_DATA'] = "<person></person>"
      put :update
      response.status.should == "422 Unprocessable Entity"
    end
    it "should fail a put with no sourced_id" do
      request.env['RAW_POST_DATA'] = "
    <person>
  <names>
    <given>Bob</given>
    <family>Jones</family>
  </names>
  <contact_info>
    <email>bob@your_school.edu</email>
  </contact_info>
</person>"
      put :update
      response.status.should == "422 Unprocessable Entity"
    end
    it "should fail a put with no given name" do
      request.env['RAW_POST_DATA'] = "<person>
  <sourced_id>bjones8</sourced_id>
  <names>
    <family>Jones</family>
  </names>
  <contact_info>
    <email>bob@your_school.edu</email>
  </contact_info>
</person>"
      put :update
      response.status.should == "422 Unprocessable Entity"
    end
    it "should fail a put with no family name" do
      request.env['RAW_POST_DATA'] = "<person>
  <sourced_id>bjones8</sourced_id>
  <names>
    <given>Bob</given>
  </names>
  <contact_info>
    <email>bob@your_school.edu</email>
  </contact_info>
</person>"
      put :update
      response.status.should == "422 Unprocessable Entity"
    end
    it "should fail a put with no email" do
      request.env['RAW_POST_DATA'] = "<person>
  <sourced_id>bjones8</sourced_id>
  <names>
    <given>Bob</given>
    <family>Jones</family>
  </names>
  <contact_info>
  </contact_info>
</person>"
      put :update
      response.status.should == "422 Unprocessable Entity"
    end
    it "should fail a put with a duplicate email" do
      request.env['RAW_POST_DATA'] = "<person>
  <sourced_id>bjones8</sourced_id>
  <names>
    <given>Bob</given>
    <family>Jones</family>
  </names>
  <contact_info>
    <email>bobjones@your_school.edu</email>
  </contact_info>
</person>"
      put :update
      response.status.should == "422 Unprocessable Entity"
    end
    it "should succeed at a put with an OK person" do
      request.env['RAW_POST_DATA'] = "<person>
  <sourced_id>bjones8</sourced_id>
  <names>
    <given>Bob</given>
    <family>Jones</family>
  </names>
  <contact_info>
    <email>bob@your_school.edu</email>
  </contact_info>
</person>"
      put :update
      response.status.should == "201 Created"
    end
  end
  describe "multi-record import" do
    it "should be able to import two people" do
      request.env['RAW_POST_DATA'] = "<person>
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
</person>"
      put :update
      response.status.should == "201 Created"
    end

  end
  describe "delete requests" do
    it "should fail with no sourced_id" do
      success = false
      begin
        delete :delete
      rescue ActionController::RoutingError
        success = true
      end
      success.should == true
    end
    it "should fail with a bad sourced_id" do
      delete :delete, :sourced_id => "jim2"
      response.status.should == "404 Not Found"
    end
    it "should succeed with a good sourced_id" do
      delete :delete, :sourced_id => "bobjones1"
      Person.count.should == 0
      response.status.should == "204 No Content"
    end
  end
  describe "replication" do
    it "should provide a URL to retrive the object"
    it "URL provided should return an object"
    it "object returned should correctly reproduce XML"
  end
end
=end