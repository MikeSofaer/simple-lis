require File.join(File.dirname(__FILE__), "helper")

Story "Provision Data", %{
  As a user
  I want to provision data
  So that the application has it
}, :type => RailsStory do

  Scenario "Creating and retrieving a person" do
    Given "some person XML" do
      @input_xml = "<person>
  <sourced_id>bobjones1</sourced_id>
  <names>
    <given>Bob</given>
    <family>Jones</family>
  </names>
  <contact_info>
    <email>bobjones@your_school.edu</email>
  </contact_info>
</person>"
    end

    And "the user has sent the person to the server", @input_xml do |xml|
      request.env['RAW_POST_DATA'] = xml
      put "/people"
    end

    When "requesting the user back", "bobjones1" do |sourced_id|
      get "/people", :sourced_id => sourced_id
    end

    Then "The XMl should be the same", @xml do |xml|
      p response
    end
  end
end