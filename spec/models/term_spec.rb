describe "Term" do
  before(:each) do
    @term = Factory.build(:term)
  end

  describe "generated XML" do
    before(:each) do
      @xml = Hpricot(@term.to_xml).term
    end
    it "should contain the correct title" do
      @xml.title.should_not be_nil
      @xml.title.should == @term.title
    end
    it "should contain the correct starts_at" do
      @xml.starts_at.should_not be_nil
      @xml.starts_at.should == @term.starts_at.to_s
    end
    it "should contain the correct ends_at" do
      @xml.ends_at.should_not be_nil
      @xml.ends_at.should == @term.ends_at.to_s
    end
    it "should contain the correct sourced_id" do
      @xml.sourced_id.should_not be_nil
      @xml.sourced_id.should == @term.sourced_id
    end
  end

  describe "generation from XML" do
    before(:each) do
      @xml = Hpricot(@term.to_xml).term
    end
    it "should create a saveable term from a valid XML" do
      Term.from_xml(@xml).save!
    end
    it "should fail without a title" do
      @xml.search('title').remove
      lambda{Term.from_xml(@xml).save!}.should raise_error(Hpricot::MissingFieldError)
    end
    it "should not fail without a starts_at" do
      @xml.search('starts_at').remove
      lambda{Term.from_xml(@xml).save!}.should_not raise_error(Hpricot::MissingFieldError)
    end
    it "should not fail without an ends_at" do
      @xml.search('ends_at').remove
      lambda{Term.from_xml(@xml).save!}.should_not raise_error(Hpricot::MissingFieldError)
    end
    it "should fail without a sourced_id" do
      @xml.search('sourced_id').remove
      lambda{Term.from_xml(@xml).save!}.should raise_error(Hpricot::MissingFieldError)
    end
  end
end