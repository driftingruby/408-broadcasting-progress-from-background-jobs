class SmallTaskJob < ApplicationJob
  queue_as :default

  def perform(current_user_id, i, total_count)
    current_user = User.find(current_user_id)
    sleep rand
    # Turbo::StreamsChannel.broadcast_replace_to ["heavy_task_channel", current_user.to_gid_param].join(":"),
    #   target: "heavy_task",
    #   partial: "heavy_tasks/progress",
    #   locals: {
    #     progress: (i + 1) * 100 / total_count
    #   }

    Turbo::StreamsChannel.broadcast_action_to ["heavy_task_channel", current_user.to_gid_param].join(":"),
      action: "append",
      target: "heavy_task",
      content: "<div></div>"
  end
end
