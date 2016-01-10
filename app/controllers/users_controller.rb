class UsersController < ApplicationController
  
  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])			#Not the final implementation!
  	if @user.save
  		# Handle a successfult save.
  	else
  		render 'new'
  	end
  end
end
