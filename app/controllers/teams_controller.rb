class TeamsController < ApplicationController

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
    @teams = Team.all
  end

  
  def show
    @team = Team.find(params[:id])
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update(team_params)
      redirect_to team_path(@team), notice: 'チームを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end


  private

  def team_params
    params.require(:team).permit(:name)
  end
end
