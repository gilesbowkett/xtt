class StatusesController < ApplicationController
  # SCOPED TO USERS
  
  def index
    @statuses = Status.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml  => @statuses }
    end
  end

  def new
    @status = Status.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml  => @status }
    end
  end

  def create
    @status = Status.new(params[:status])

    respond_to do |format|
      if @status.save
        flash[:notice] = 'Status was successfully created.'
        format.html { redirect_to(@status) }
        format.xml  { render :xml  => @status, :status => :created, :location => @status }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml  => @status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # TOP LEVEL
  
  def show
    @status = Status.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml  => @status }
    end
  end

  def edit
    @status = Status.find(params[:id])
  end

  def update
    @status = Status.find(params[:id])

    respond_to do |format|
      if @status.update_attributes(params[:status])
        flash[:notice] = 'Status was successfully updated.'
        format.html { redirect_to(@status) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml  => @status.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @status = Status.find(params[:id])
    @status.destroy

    respond_to do |format|
      format.html { redirect_to(statuses_url) }
      format.xml  { head :ok }
    end
  end
end
