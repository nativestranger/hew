class CallCleanupJob < ApplicationJob
  def perform
    return if ENV['preserve_calls'] == 'true'

    User.system.calls.where(
    "entry_deadline < ?", Time.current
    ).find_in_batches { |calls| calls.each(&:destroy) }
  end
end  