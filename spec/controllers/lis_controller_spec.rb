require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LisController do
  context "Course Offerings" do
    before(:each) do
      @offering = Factory(:course_offering)
    end
  
    it "should return a URL to an offering" do
      get :index, :resource => 'course_offerings'
      Hpricot(response.body).search('sourced_id').inner_text.should == @offering.sourced_id
    end
  
    it "should allow you to retrieve the offering" do
      get :index, :resource => 'course_offerings', :sourced_id => @offering.sourced_id
      Hpricot(response.body).search('sourced_id').inner_text.should == @offering.sourced_id
    end
  
    it "should allow you to delete the offering" do
      lambda {
        delete :destroy, :resource => 'course_offerings', :sourced_id => @offering.sourced_id
      }.should change(CourseOffering.datamapper_class, :count).by(-1)
      response.status.should == "204 No Content"
    end
  
    it "should not allow you to delete the offering if there is a section" do
      Factory(:course_section, :course_offering => @offering)
      lambda {
        delete :destroy, :resource => 'course_offerings', :sourced_id => @offering.sourced_id
      }.should change(CourseOffering.datamapper_class, :count).by(0)
      response.body.match(/foreign key constraint fails/).should_not be_nil
      response.status.should == "422 Unprocessable Entity"
    end
    
    it "should allow you to create an offering with a template and term that both exist" do
      term = Factory(:term)
      xml = Hpricot(@offering.to_xml)
      xml.at('term_sourced_id').swap "<term_sourced_id>#{term.sourced_id}</term_sourced_id>"
      xml.at('sourced_id').swap "<sourced_id>New sourced_id</sourced_id>"
      request.env['RAW_POST_DATA'] = xml.to_s
      go = lambda {put :update, :resource => 'course_offerings'}
      go.should change(CourseOffering.datamapper_class, :count).by(1)
      response.status.should == "200 OK"
    end
    
    it "should not allow you to create an offering if an offering with that term and template already exists" do
      xml = Hpricot(@offering.to_xml)
      xml.at('sourced_id').swap "<sourced_id>New sourced_id</sourced_id>"
      request.env['RAW_POST_DATA'] = xml.to_s
      go = lambda {put :update, :resource => 'course_offerings'}
      go.should_not change(CourseOffering.datamapper_class, :count)
      #This is a little sketchy, it would be nice to warn that the object was not created
    end
    
    it "should not allow you to create an offering if there is no relevant course template" do
      Factory(:course_template)
      xml1 = Hpricot(@offering.to_xml)
      xml2 = Hpricot(@offering.to_xml)
      xml1.at('course_template_sourced_id').swap "<course_template_sourced_id>Fake ID</course_template_sourced_id>"
      xml1.at('sourced_id').swap "<sourced_id>New sourced_id</sourced_id>"
      request.env['RAW_POST_DATA'] = '<xml>' + xml1.to_s + xml2.to_s + '</xml>'
      go = lambda {put :update, :resource => 'course_offerings'}
      go.should_not change(CourseOffering.datamapper_class, :count)
      response.status.should == "422 Unprocessable Entity"
      response.body.should match(/Fake ID/)
      response.body.should_not match(/#{CourseTemplate.datamapper_class.first.sourced_id}/)
    end
    
    it "should not allow you to create an offering if there is no relevant term" do
      xml = Hpricot(@offering.to_xml)
      xml.at('term_sourced_id').swap "<term_sourced_id>Fake ID</term_sourced_id>"
      request.env['RAW_POST_DATA'] = xml.to_s
      go = lambda {put :update, :resource => 'course_offerings'}
      go.should_not change(CourseOffering.datamapper_class, :count)
      response.status.should == "422 Unprocessable Entity"
      response.body.should match(/Fake ID/)
    end
  end

  context "Meetings" do
    describe "put requests" do
      it "should fail at a put with a meeting with unknown section" do
        request.env['RAW_POST_DATA'] = "<meetings><meeting>
    <sourced_id>sample2</sourced_id>
    <target_sourced_id>does-not-exist</target_sourced_id>
    <target_type>Section</target_type>
    <i_calendar>BEGIN:VCALENDAR
CALSCALE:GREGORIAN
PRODID:-//Apple Computer, Inc//iCal 1.5//EN
VERSION:2.0
METHOD:REPLY
BEGIN:VEVENT
CLASS:PUBLIC
DTEND;TZID=Pacific:20040415T130000
DTSTAMP:20040319T205045Z
DTSTART;TZID=Pacific:20040415T120000
SEQUENCE:0
SUMMARY:hjold intyel
TRANSP:OPAQUE
UID:3E19204063C93D2388256E5C006BF8D9-Lotus_Notes_Generated
X-LOTUS-BROADCAST:FALSE
X-LOTUS-CHILDUID:3E19204063C93D2388256E5C006BF8D9
X-LOTUS-NOTESVERSION:2
X-LOTUS-NOTICETYPE:I
X-LOTUS-UPDATE-SEQ:1
X-LOTUS-UPDATE-WISL:$S:1;$L:1;$B:1;$R:1;$E:1
END:VEVENT
END:VCALENDAR
</i_calendar>
    </meeting></meetings>"
        put :update, :resource => 'meetings'
        response.status.should == "422 Unprocessable Entity"
      end

      it "should suceed at a put with a good meeting" do
        request.env['RAW_POST_DATA'] = "<meetings><meeting>
    <sourced_id>sample2</sourced_id>
    <target_sourced_id>#{Factory(:course_section).sourced_id}</target_sourced_id>
    <target_type>Section</target_type>
    <i_calendar>BEGIN:VCALENDAR
CALSCALE:GREGORIAN
PRODID:-//Apple Computer, Inc//iCal 1.5//EN
VERSION:2.0
METHOD:REPLY
BEGIN:VEVENT
CLASS:PUBLIC
DTEND;TZID=Pacific:20040415T130000
DTSTAMP:20040319T205045Z
DTSTART;TZID=Pacific:20040415T120000
SEQUENCE:0
SUMMARY:hjold intyel
TRANSP:OPAQUE
UID:3E19204063C93D2388256E5C006BF8D9-Lotus_Notes_Generated
X-LOTUS-BROADCAST:FALSE
X-LOTUS-CHILDUID:3E19204063C93D2388256E5C006BF8D9
X-LOTUS-NOTESVERSION:2
X-LOTUS-NOTICETYPE:I
X-LOTUS-UPDATE-SEQ:1
X-LOTUS-UPDATE-WISL:$S:1;$L:1;$B:1;$R:1;$E:1
END:VEVENT
END:VCALENDAR
</i_calendar>
    </meeting></meetings>"
        put :update, :resource => 'meetings'
        response.status.should == "200 OK"
      end
    end
  end

  context "Memberships" do
    before(:each) do
      @section1 = Factory(:course_section)
      @section2 = Factory(:course_section, :course_offering => CourseOffering.datamapper_class.first(:sourced_id => @section1.course_offering_sourced_id))
      @person1 = Factory(:person)
      @person2 = Factory(:person)
      @m1 = Factory(:membership, :target => @section1, :person => @person1)
      @m2 = Factory(:membership, :target => @section2, :person => @person2)
    end

    it "should give all section memberships" do
      get :index, :resource => 'memberships'
      ids = Hpricot(response.body).search('sourced_id').map(&:inner_text)
      ids.member?(@m1.sourced_id).should be_true
      ids.member?(@m2.sourced_id).should be_true
    end

    it "should give only a user's memberships" do
      get :index, :resource => 'memberships', :parent => 'people', :parent_sourced_id => @person1.sourced_id
      ids = Hpricot(response.body).search('sourced_id').map(&:inner_text)
      ids.member?(@m1.sourced_id).should be_true
      ids.member?(@m2.sourced_id).should be_false
    end
  end

  context "People" do
    describe "get requests" do
      before(:each) do
        Factory(:person, :sourced_id => "bobjones1")
      end
      
      it "should have built the person" do
        Person.datamapper_class.first(:sourced_id => "bobjones1").should_not be_nil
      end
    
      it "should return a list of people on index" do
        get :index, :resource => 'people'
        doc = Hpricot(response.body)
        user = Person.parse(doc.to_s)
        user.class.should == Person
        response.status.should == "200 OK"
      end
    
      it "should return a person on show" do
        get :show, :sourced_id => "bobjones1", :resource => 'people'
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

      it "should fail if the xml is invalid" do
        request.env['RAW_POST_DATA'] = "<people><person><sourced_id>test</soknf></person></people>"
        put :update, :resource => 'people'
        response.status.should == "422 Unprocessable Entity"
        response.body.match(/We weren't able to parse any data from that./).should_not be_nil
      end
      it "should fail a put with an empty person" do
        request.env['RAW_POST_DATA'] = "<person></person>"
        put :update, :resource => 'people'
        response.status.should == "422 Unprocessable Entity"
      end

      it "should fail a put with no sourced_id" do
        @xml.search('sourced_id').remove
        request.env['RAW_POST_DATA'] = @xml.to_s
        put :update, :resource => 'people'
        response.status.should == "422 Unprocessable Entity"
      end

      it "should succeed on a put with a duplicate email" do  #I'd change this, but it's not easy to do, due to ON DUPLICATE KEY UPDATE

        Factory(:person, :email => "bob@your_school.edu")

        request.env['RAW_POST_DATA'] = @xml.to_s
        lambda{ put :update, :resource => 'people' }.should change(Person.datamapper_class, :count).by(1)
        response.status.should == "200 OK"
      end

      it "should succeed at a put with an OK person" do
        request.env['RAW_POST_DATA'] = @xml.to_s
        lambda{ put :update, :resource => 'people' }.should change(Person.datamapper_class, :count).by(1)
        response.status.should == "200 OK"
      end
      
      it "should change the information of a person already in the DB" do
        person = Factory(:person)
        Person.datamapper_class.first.email.should_not == "bob@your_school.edu"
        @xml.at('sourced_id').swap "<sourced_id>#{person.sourced_id}</sourced_id>"
        request.env['RAW_POST_DATA'] = @xml.to_s
        lambda{ put :update, :resource => 'people' }.should_not change(Person.datamapper_class, :count)
        response.status.should == "200 OK"
        Person.datamapper_class.first.email.should == "bob@your_school.edu"
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
        go = lambda{put :update, :resource => 'people'}
        go.should change(Person.datamapper_class, :count).by(2)
        response.status.should == "200 OK"
      end

    end

    describe "delete requests" do
      before(:each) do
        @person = Factory(:person, :sourced_id => "bobjones1")
      end

      it "should fail with no sourced_id" do
        go = lambda{delete :destroy}
        go.should raise_error(ActionController::RoutingError)
      end

      it "should fail with a bad sourced_id" do
        delete :destroy, :sourced_id => "jim2", :resource => 'people'
        response.status.should == "404 Not Found"
      end

      it "should succeed with a good sourced_id" do
        go = lambda{delete :destroy, :sourced_id => "bobjones1", :resource => 'people'}
        go.should change(Person.datamapper_class, :count).by(-1)
        response.status.should == "204 No Content"
      end

      it "should delete the person's memberships" do
        Factory(:membership, :person => @person) #it gets stuck here, so commenting this out until we fix the factories
        go = lambda{delete :destroy, :sourced_id => "bobjones1", :resource => 'people'}
        go.should change(Membership.datamapper_class, :count).by(-1)
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
      
      context "on PUT to :update" do
        before(:each) do
          request.env['RAW_POST_DATA'] = @xml.to_s
          put :update, :resource => 'people'
        end
        
        it "should provide a URL to retrive the object" do
          response.body.should == "<url>http://test.host/people/bjones8</url>"
        end
        
        it "on GET to :show on the same sourced_id should return the correct XML" do
          get :show, :sourced_id => 'bjones8', :resource => 'people'
          response.body.should == @xml.at('person').to_s
        end
      end
    end
  end
end