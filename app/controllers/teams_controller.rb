class TeamsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to root_path,  notice: 'チームを作成しました'
    else
      render :new, status: :unprocessable_entity
    end 
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
