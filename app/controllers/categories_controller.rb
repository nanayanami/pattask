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
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
