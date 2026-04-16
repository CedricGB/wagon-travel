class PlansController < ApplicationController
  def index
    @plans = Plan.where(user_id: current_user)
  end

  def show
    @plan = Plan.find(params[:id])
    @message = Message.new
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)
    @plan.user = current_user
    if @plan.save
      redirect_to plan_path(@plan)
    else
      render :new, status: :unprocessable_entity
    end
    @plan.chat = Chat.new
  end

  def destroy
    @plan = Plan.find(params[:id])
    if @plan.destroy
      redirect_to plans_path
    else
      redirect_to plan_path(@plan)
    end
  end

  def update
    @plan = Plan.find(params[:id])
    @plan.user = current_user
    if @plan.update(plan_params)
      redirect_to plan_path(@plan)
    else
      render :new, status: :unprocessable_entity

    end
  end

  private

  def plan_params
    params.require(:plan).permit(:title, :departure, :arrival, :date_start, :date_end, :budget)
  end
end
