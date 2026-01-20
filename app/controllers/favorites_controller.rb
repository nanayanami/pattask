class FavoritesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    favorite = post.favorites.find_or_initialize_by(user: current_user)
    favorite.save
    redirect_to team_category_post_path(params[:team_id], params[:category_id], post)
  end

  def destroy
    post = Post.find(params[:post_id])
    favorite = post.favorites.find_by(user: current_user)
    favorite&.destroy
    redirect_to team_category_post_path(params[:team_id], params[:category_id], post)
  end
end
