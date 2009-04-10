require File.dirname(__FILE__) + '/../spec_helper'

# spec_helper defines and includes module with Issue helper functions
describe Issue, "which already exists with an open status" do

  before(:each) do
    @issue = build_issue_with_required_associations
    stub_mailer
    @issue.save
  end  

  it "should be valid before the testing begins" do
    @issue.new_record?.should_not be_true
    @issue.should be_valid
  end

  describe "when the status is changed to closed" do
    before(:each) do
      @closed_status = IssueStatus.create(:name => "Closed Status", :is_closed => true)
    end
    
    it "should be invalid if no new note is provided" do
      # First init journal w/ no notes
      @issue.init_journal(@issue.author, "")
      @issue.status_id = @closed_status.id
      @issue.save.should be_false
    end
    
    it "should be valid if a new note is provided" do
      @issue.init_journal(@issue.author, "Explanation for the save")
      @issue.status = @closed_status
      @issue.save.should be_true
    end
  end
  
  describe "when the status is changed, but the issue is still open" do
    before(:each) do
      # Start w/ an open status
      @new_status = IssueStatus.create(:name => "New different status", :is_closed => false)
    end
    
    it "should be valid if no note is provided" do
      @issue.init_journal(@issue.author, "")
      @issue.status = @new_status
      @issue.save.should be_true
    end
    
    it "should be valid if a note is provided" do
      @issue.init_journal(@issue.author, "")
      @issue.status = @new_status
      @issue.save.should be_true
    end
  end
end

describe Issue, "which already exists with a closed status" do
  before(:each) do
    @issue = build_issue_with_required_associations
    @issue.status = IssueStatus.create(:name => "Original closed status", :is_closed => true)
    stub_mailer
    @issue.save
  end
  

  it "should be valid before the testing begins" do
    @issue.new_record?.should_not be_true
    @issue.should be_valid
  end

  describe "when updated and the status remains closed" do
    before(:each) do
      @closed_status = IssueStatus.create(:name => "Closed Status", :is_closed => true)
    end
    
    it "should be valid if no new note is provided" do
      # First init journal w/ no notes
      @issue.init_journal(@issue.author, "")
      @issue.status = @closed_status
      @issue.save.should be_true
    end
    
    it "should be valid if a new note is provided" do
      @issue.init_journal(@issue.author, "Explanation for the save")
      @issue.status = @closed_status
      @issue.save.should be_true
    end
  end
  
end