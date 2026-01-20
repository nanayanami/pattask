class PostsController < ApplicationController
  before_action :set_team
  before_action :set_category

  def new
    @post = @category.posts.build
  end

  def create
    @post = @category.posts.build(post_params)
    @post.team_id = @team.id
    @post.user = current_user
    if @post.save
      redirect_to team_category_posts_path(@team, @category), notice: '投稿を作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @posts = @category.posts.page(params[:page]).reverse_order
  end

  def show
    @post = @category.posts.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(7).reverse_order
  end

  def edit
    @post = @category.posts.find(params[:id])
  end

  def update
    @post = @category.posts.find(params[:id])
    @post.user ||= current_user
    if @post.update(post_params)
      redirect_to team_category_post_path(@team, @category, @post), notice: '投稿を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = @category.posts.find(params[:id])
    if @post.destroy
      redirect_to team_category_posts_path(@team, @category), notice: '投稿を削除しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end



  
  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_category
    @category = @team.categories.find(params[:category_id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :image_id, :status)
  end
end
