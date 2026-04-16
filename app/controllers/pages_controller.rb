class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
    if user_signed_in?
      @plans = current_user.plans
    else
      @plans = Plan.all
    end
  end

  def index
    @plans = Plan.where(public: true)
    
    # if user_signed_in?
    #   @plans = current_user.plans
    # else
    #   @plans = Plan.where(public: true)
    # end
  end
end
