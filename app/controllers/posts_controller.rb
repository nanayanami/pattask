class PostsController < ApplicationController
  before_action :set_team
  before_action :set_category
  before_action :set_post, only: %i[show edit update destroy]

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
    if params[:search].present?
      query = "%#{params[:search]}%"
      @posts = @posts
               .left_joins(:rich_text_content)
               .where('posts.title LIKE :q OR action_text_rich_texts.body LIKE :q', q: query)
    end
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(7).reverse_order
  end

  def edit
  end

  def update
    @post.user ||= current_user
    if @post.update(post_params)
      redirect_to team_category_post_path(@team, @category, @post), notice: '投稿を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
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

  def set_post
    @post = @category.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:user_id, :title, :content, :image_id, :status)
  end
end
