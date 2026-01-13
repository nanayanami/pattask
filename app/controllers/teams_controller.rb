class TeamsController < ApplicationController

  def show
    @team = Team.find(params[:id])
  end

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

  def edit
  end

  def update
  end


  private

  def team_params
    params.require(:team).permit(:name)
  end
end
