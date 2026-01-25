class PostsController < ApplicationController
  before_action :set_team, except: %i[confirm favorites]
  before_action :set_category, except: %i[confirm favorites]
  before_action :set_post, only: %i[show edit update destroy update_progress complete uncomplete]

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
    @posts = @category.posts.published.page(params[:page]).reverse_order
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

  def update_progress
    unless Post.progress_statuses.key?(params[:progress_status])
      return redirect_back fallback_location: team_category_post_path(@team, @category, @post), alert: "不正な進捗です"
    end

    if @post.update(progress_status: params[:progress_status])
      redirect_back fallback_location: team_category_post_path(@team, @category, @post), notice: "進捗を更新しました"
    else
      redirect_back fallback_location: team_category_post_path(@team, @category, @post), alert: "進捗の更新に失敗しました"
    end
  end

  def complete
    if @post.update(completed: true)
      redirect_back fallback_location: team_category_post_path(@team, @category, @post), notice: "完了にしました"
    else
      redirect_back fallback_location: team_category_post_path(@team, @category, @post), alert: "完了にできませんでした"
    end
  end

  def uncomplete
    if @post.update(completed: false)
      redirect_back fallback_location: team_category_post_path(@team, @category, @post), notice: "進捗に戻しました"
    else
      redirect_back fallback_location: team_category_post_path(@team, @category, @post), alert: "進捗に戻せませんでした"
    end
  end

  def destroy
    if @post.destroy
      redirect_to team_category_posts_path(@team, @category), notice: '投稿を削除しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm
    @posts = current_user.posts.draft.page(params[:page]).reverse_order
  end

  def favorites
    @posts = Post.joins(:favorites)
                 .where(favorites: { user_id: current_user.id })
                 .includes(:team, :category, :user)
                 .page(params[:page])
                 .reverse_order
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
    params.require(:post).permit(:user_id, :title, :content, :image_id, :status, :progress_status, :completed)
  end
end
