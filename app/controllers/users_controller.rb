# encoding: utf-8
class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :find_user, only: [:edit, :update,:destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :can_destroy, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end


  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "删除成功！"
    else
      flash[:error] = "删除失败！"
    end
    redirect_to users_path
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def find_user
      @user = User.find(params[:id])
    end

    def correct_user
      redirect_to(root_path) unless current_user? @user
    end

    def can_destroy
      redirect_to(root_path) if !current_user.admin? || current_user?(@user)
      #if current_user.admin?
        #p "============"
      #end
      #p current_user
      #p @user
      #if current_user?(@user)
        #p "-----------"
      #end

    end


end
