class UserSessionsController < ApplicationController
  
  def new
    @user_session = UserSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_session }
    end
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
 
    respond_to do |format|
      if @user_session.save
        format.html { redirect_to(:users, :notice => 'Login Successful') }
        format.xml  { render :xml => @user_session, :status => :created, :location => @user_session }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_session.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /user_sessions/1
  # PUT /user_sessions/1.json
  def update
    @user_session = UserSession.find(params[:id])

    respond_to do |format|
      if @user_session.update_attributes(params[:user_session])
        format.html { redirect_to @user_session, notice: 'User session was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.json
  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    respond_to do |format|
      format.html { redirect_to user_sessions_url }
      format.json { head :no_content }
    end
  end
end
