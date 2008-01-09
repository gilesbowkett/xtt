require File.dirname(__FILE__) + '/../spec_helper'

# USER SCOPE

describe StatusesController, "GET #index for user" do
  define_models

  act! { get :index, :user_id => users(:default).id }

  before do
    @record   = @user = users(:default)
    @statuses = [statuses(:default)]
    controller.stub!(:login_required)
  end
  
  it_assigns :statuses, :record, :user
  it_renders :template, :index

  describe StatusesController, "(xml)" do
    define_models
    
    act! { get :index, :user_id => users(:default).id, :format => 'xml' }

    it_assigns :statuses, :record, :user
    it_renders :xml, :statuses
  end
end

describe StatusesController, "GET #index for project" do
  define_models

  act! { get :index, :project_id => projects(:default).id }

  before do
    @record   = @project = projects(:default)
    @statuses = [statuses(:default)]
    controller.stub!(:login_required)
  end
  
  it_assigns :statuses, :record, :project
  it_renders :template, :index

  describe StatusesController, "(xml)" do
    define_models
    
    act! { get :index, :project_id => projects(:default).id, :format => 'xml' }

    it_assigns :statuses, :record, :project
    it_renders :xml, :statuses
  end
end

describe StatusesController, "GET #new" do
  define_models
  act! { get :new, :user_id => users(:default).id }
  before do
    @status  = Status.new
    controller.stub!(:login_required)
  end

  it "assigns @status" do
    act!
    assigns[:status].should be_new_record
  end
  
  it_renders :template, :new
  
  describe StatusesController, "(xml)" do
    define_models
    act! { get :new, :user_id => users(:default).id, :format => 'xml' }

    it_renders :xml, :status
  end
end

describe StatusesController, "POST #create" do
  before do
    @attributes = {:message => 'foo'}
    @status = Status.new(@attributes)
    @user = users(:default)
    @user.stub!(:statuses).and_return([])
    @user.statuses.stub!(:before).and_return(nil)
    @user.statuses.stub!(:build).and_return(@status)
    @status.user = @user
    User.stub!(:find).with(@user.id.to_s).and_return(@user)
    controller.stub!(:login_required)
  end
  
  describe StatusesController, "(successful creation)" do
    define_models
    act! { post :create, :user_id => users(:default).id, :status => @attributes }
    
    it_assigns :user, :status, :flash => { :notice => :not_nil }
    it_redirects_to { user_path(@user) }
  end

  describe StatusesController, "(unsuccessful creation)" do
    define_models
    act! { post :create, :user_id => users(:default).id, :status => @attributes }

    before do
      @status.message = nil
      controller.stub!(:login_required)
    end
    
    it_assigns :user, :status
    it_renders :template, :new
  end
  
  describe StatusesController, "(successful creation, xml)" do
    define_models
    act! { post :create, :user_id => users(:default).id, :status => @attributes, :format => 'xml' }
    
    it_assigns :user, :status, :headers => { :Location => lambda { status_url(@status) } }
    it_renders :xml, :status, :status => :created
  end
  
  describe StatusesController, "(unsuccessful creation, xml)" do
    define_models
    act! { post :create, :user_id => users(:default).id, :status => @attributes, :format => 'xml' }

    before do
      @status.message = nil
      controller.stub!(:login_required)
    end
    
    it_assigns :user, :status
    it_renders :xml, "status.errors", :status => :unprocessable_entity
  end
end

# GLOBAL SCOPE

describe StatusesController, "GET #show" do
  define_models

  act! { get :show, :id => 1 }

  before do
    @status  = statuses(:default)
    Status.stub!(:find).with('1').and_return(@status)
    controller.stub!(:login_required)
  end
  
  it_assigns :status
  it_renders :template, :show
  
  describe StatusesController, "(xml)" do
    define_models
    
    act! { get :show, :id => 1, :format => 'xml' }

    it_renders :xml, :status
  end
end

describe StatusesController, "PUT #update" do
  before do
    @attributes = {}
    @status = statuses(:default)
    Status.stub!(:find).with('1').and_return(@status)
    controller.stub!(:login_required)
  end
  
  describe StatusesController, "(successful save)" do
    define_models
    act! { put :update, :id => 1, :status => @attributes }

    before do
      @status.stub!(:save).and_return(true)
      controller.stub!(:login_required)
    end
    
    it_assigns :status, :flash => { :notice => :not_nil }
    it_redirects_to { status_path(@status) }
  end

  describe StatusesController, "(unsuccessful save)" do
    define_models
    act! { put :update, :id => 1, :status => @attributes }

    before do
      @status.stub!(:save).and_return(false)
      controller.stub!(:login_required)
    end
    
    it_assigns :status
    it_renders :template, :edit
  end
  
  describe StatusesController, "(successful save, xml)" do
    define_models
    act! { put :update, :id => 1, :status => @attributes, :format => 'xml' }

    before do
      @status.stub!(:save).and_return(true)
      controller.stub!(:login_required)
    end
    
    it_assigns :status
    it_renders :blank
  end
  
  describe StatusesController, "(unsuccessful save, xml)" do
    define_models
    act! { put :update, :id => 1, :status => @attributes, :format => 'xml' }

    before do
      @status.stub!(:save).and_return(false)
      controller.stub!(:login_required)
    end
    
    it_assigns :status
    it_renders :xml, "status.errors", :status => :unprocessable_entity
  end
end

describe StatusesController, "DELETE #destroy" do
  define_models
  act! { delete :destroy, :id => 1 }
  
  before do
    @status = statuses(:default)
    @status.stub!(:destroy)
    Status.stub!(:find).with('1').and_return(@status)
    controller.stub!(:login_required)
  end

  it_assigns :status
  it_redirects_to { statuses_path }
  
  describe StatusesController, "(xml)" do
    define_models
    act! { delete :destroy, :id => 1, :format => 'xml' }

    it_assigns :status
    it_renders :blank
  end
end