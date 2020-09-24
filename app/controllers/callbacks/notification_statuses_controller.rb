module Callbacks
  class NotificationStatusesController < CallbacksController
    def create
      case received_status
      when "delivered"
        notification.update!(
          state: status_params.fetch(:status),
          delivered_at: status_params.fetch(:completed_at),
        )
      when "temporary-failure" || "technical-failure"
        notification.update! state: :enqueued
        DeliverNotificationJob.perform_later notification
      when "permanent-failure"
        notification.update! state: :failed, failed_at: status_params.fetch(:completed_at)
      end
      head :created
    end

    private

      def received_status
        status_params.fetch(:status)
      end

      def status_params
        params.slice :id, :reference, :to, :status, :sent_at, :completed_at
      end

      def notification
        Notification.find status_params.fetch(:reference)
      end
  end
end
