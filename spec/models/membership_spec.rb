require File.dirname(__FILE__) + '/../spec_helper'

describe Membership do
  define_models :memberships do
    model Membership do
      stub :user => all_stubs(:user), :project => all_stubs(:another_project), :code => 'foo'
    end
    model Context
  end
  
  it "knows arbitrary users are not project members" do
    projects(:default).user_id = nil
    projects(:default).users.include?(users(:default)).should == false
  end
  
  it "recognizes project owners as members" do
    projects(:default).users.include?(users(:default)).should == true
  end
  
  it "adds users as project members" do
    projects(:default).user_id = nil
    Membership.create! :user => users(:default), :project => projects(:default), :code => 'test'
    projects(:default).users.include?(users(:default)).should == true
  end

  it "doesn't allow duplicates" do
    Membership.create!(:user_id => 1, :project_id => 1, :code => 'test')
    m = Membership.new :user_id => 1, :project_id => 1, :code => 'other'
    m.should_not be_valid
  end

  it "raises InvalidCodeError on bad codes" do
    lambda { Membership.find_by_code("fido") }.should raise_error(Membership::InvalidCodeError)
  end
  
  it "requires a code unique to the user" do
    Membership.create(:user_id => 1, :project_id => 1, :code => 'test')
    m = Membership.new(:user_id => 1, :project_id => 2, :code => 'test')
    m.should have(1).error_on(:code)
  end
  
  it "sets the context from context_name" do
    memberships(:default).context_name = "foo"
    memberships(:default).context.should be_an_instance_of(Context)
    memberships(:default).context.name.should == "foo"
  end
  
end

describe_validations_for Membership, :user_id => 1, :project_id => 1 do
  presence_of :user_id, :project_id
end