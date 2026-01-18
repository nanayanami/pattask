class CategoriesController < ApplicationController
  before_action :set_team

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
    @categories = @team.categories
  end

  def show
    @category = @team.categories.find(params[:id])
    @posts = @category.posts
  end

  def edit
    @category = @team.categories.find(params[:id])
  end

  def update
    @category = @team.categories.find(params[:id])
    if @category.update(category_params)
      redirect_to team_category_path(@team, @category), notice: 'カテゴリーを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category = @team.categories.find(params[:id])
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

  def category_params
    params.require(:category).permit(:name)
  end
end
