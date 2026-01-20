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
  end

  def show
    @posts = @category.posts.page(params[:page]).reverse_order
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
end
