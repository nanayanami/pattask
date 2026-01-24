class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to team_path(@team), notice: 'チームを作成しました'
    else
      render :new, status: :unprocessable_entity
    end 
  end

  def index
    @teams = Team.page(params[:page]).reverse_order
    @teams = @teams.where('name LIKE ?', "%#{params[:search]}%") if params[:search].present?
  end

  
  def show
    @categories = @team.categories.page(params[:page]).reverse_order
    @categories = @categories.where('name LIKE ?', "%#{params[:search]}%") if params[:search].present?
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to team_path(@team), notice: 'チームを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @team.destroy
      redirect_to teams_path, notice: 'チームを削除しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end


  private

  def team_params
    params.require(:team).permit(:name)
  end

  def set_team
    @team = Team.find(params[:id])
  end
end
