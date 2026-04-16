class LogementsController < ApplicationController
  def show

    @logement = Logement.find(params[:id])
    @plan = @logement.plan
  end

  def index
    @plan = Plan.find(params[:plan_id])
    @logements = Logement.where(plan_id: params[:plan_id])
  end

  def new
    @plan = Plan.find(params[:plan_id])
    @logement = Logement.new
  end

  def create
    @logement = Logement.new(logement_params)
    @plan = Plan.find(params[:plan_id])
    @logement.plan = @plan
    if @logement.save
      redirect_to plan_logement_path(@plan, @logement)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @logement = Logement.find(params[:id])
    @plan = @logement.plan
  end

  def update
    @logement = Logement.find(params[:id])
    @plan = @logement.plan
    @logement.update(logement_params)

    redirect_to plan_logement_path(@plan, @logement)
  end

  private

  def logement_params
    params.require(:logement).permit(:cost,:name)
  end
end
