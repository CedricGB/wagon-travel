class ActivitiesController < ApplicationController
  def show
    @activity = Activity.find(params[:id])
    @plan = @activity.plan
  end

  def index
    @plan = Plan.find(params[:plan_id])
    @activities = Activity.where(plan_id: params[:plan_id])
  end

  def new
    @activity = Activity.new
    @plan = Plan.find(params[:plan_id])
  end

  def create
    @plan = Plan.find(params[:plan_id])
    @activity = Activity.new(activity_params)
    @activity.plan = @plan

    if @activity.save
      redirect_to plan_path(@plan)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @activity = Activity.find(params[:id])
    @plan = @activity.plan
  end

  def update
    @activity = Activity.find(params[:id])
    @plan = @activity.plan
    @activity.update(activity_params)

    if @activity.update(activity_params)
      redirect_to plan_path(@plan)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @activity = Activity.find(params[:id])
    @plan = @activity.plan
    if @activity.destroy
      redirect_to plan_path(@plan)
    end
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :cost)
  end
end
