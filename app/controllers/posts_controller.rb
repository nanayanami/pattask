class PostsController < ApplicationController
  before_action :set_team
  before_action :set_category

  def new
    @post = @category.posts.build
  end

  def create
    @post = @category.posts.build(post_params)
    @post.team_id = @team.id
    if @post.save
      redirect_to team_category_posts_path(@team, @category), notice: '投稿を作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @posts = @category.posts
  end

  def show
    @post = @category.posts.find(params[:id])
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_category
    @category = @team.categories.find(params[:category_id])
  end

  def post_params
    params.require(:post).permit(:title, :post, :image_id, :status, :user_id)
  end
end
