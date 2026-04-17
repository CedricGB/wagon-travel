class TransportsController < ApplicationController

  def show
    @transport = Transport.find(params[:id])
    @plan = @transport.plan
  end

  def index
    @transports = Transport.where(plan_id: params[:plan_id])
    @plan = Plan.find(params[:plan_id])
  end

  def new
    @plan = Plan.find(params[:plan_id])
    @transport = Transport.new
  end

  def create
    @transport = Transport.new(transport_params)
    @plan = Plan.find(params[:plan_id])
    @transport.plan = @plan
    if @transport.save
      redirect_to plan_path(@plan)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @transport = Transport.find(params[:id])
    @plan = @transport.plan
  end

  def update
    @transport = Transport.find(params[:id])
    @plan = @transport.plan
    @transport.update(transport_params)

    if @transport.update(transport_params)
      redirect_to plan_path(@plan)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transport = Transport.find(params[:id])
    @plan = @transport.plan
    if @transport.destroy
      redirect_to plan_path(@plan)
    end
  end

  private

  def transport_params
    params.require(:transport).permit(:name, :cost)
  end
end
