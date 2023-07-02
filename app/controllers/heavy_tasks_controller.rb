class HeavyTasksController < ApplicationController
  before_action :authenticate_user!

  def create
    HeavyTaskJob.perform_later(current_user.id)
  end
end
