class DashboardController < ApplicationController
  before_filter :authenticate_user!
  skip_authorization_check
  # GET /dashboard
  # GET /dashboard.json
  def index
    @meals = current_user.meals

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end
end
