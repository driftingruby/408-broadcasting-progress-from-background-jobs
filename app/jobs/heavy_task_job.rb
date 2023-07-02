class HeavyTaskJob < ApplicationJob
  queue_as :default
  before_perform :broadcast_initial_update

  def perform(current_user_id)

    total_count.times do |i|
      SmallTaskJob.perform_later(current_user_id, i, total_count)
    end
  end

  private

  def broadcast_initial_update
    Turbo::StreamsChannel.broadcast_replace_to ["heavy_task_channel", current_user.to_gid_param].join(":"),
      target: "heavy_task",
      partial: "heavy_tasks/progress",
      locals: {
        total_count: total_count
      }
  end

  def total_count
    @total_count ||= rand(10..100)
  end

  def current_user
    @current_user ||= User.find(self.arguments.first)
  end
end
