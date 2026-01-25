class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :follows, :followers, :destroy]

  def index
    @users = User.page(params[:page]).per(5).reverse_order
  end

  def show
    @posts = @user.posts.page(params[:page]).per(10).reverse_order
    @following_users = @user.following_user
    @follower_users = @user.follower_user
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'ユーザー情報を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def follows
    @users = @user.following_user.page(params[:page]).per(4).reverse_order
  end

  def followers
    @users = @user.follower_user.page(params[:page]).per(4).reverse_order
  end

  def destroy
    @user.destroy
    redirect_to root_path, notice: 'ユーザーを削除しました'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile, :profile_image)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
