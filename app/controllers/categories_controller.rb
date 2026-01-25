class CategoriesController < ApplicationController
  before_action :set_team
  before_action :set_category, only: %i[show edit update destroy]

  def new
    @category = @team.categories.build
  end

  def create
    @category = @team.categories.build(category_params)
    if @category.save
      redirect_to team_category_path(@team, @category), notice: 'カテゴリーを作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @categories = @team.categories.page(params[:page]).reverse_order
    @categories = @categories.where('name LIKE ?', "%#{params[:search]}%") if params[:search].present?
  end

  def show
    @posts = @category.posts.published.page(params[:page]).reverse_order
    if params[:search].present?
      query = "%#{params[:search]}%"
      @posts = @posts
               .left_joins(:rich_text_content)
               .where('posts.title LIKE :q OR action_text_rich_texts.body LIKE :q', q: query)
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to team_category_path(@team, @category), notice: 'カテゴリーを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      redirect_to team_categories_path(@team), notice: 'カテゴリーを削除しました'
    else
      render :edit, status: :unprocessable_entity
    end

    def confirm
      @posts =current_user.posts.draft.page(params[:page]).reverse_order
    end
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_category
    @category = @team.categories.find_by(id: params[:id])
    return if @category

    redirect_to team_categories_path(@team), alert: 'カテゴリーが見つかりません'
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def post_params
    params.require(:post).permit(:user_id, :title, :content, :image_id, :status)
  end
end
