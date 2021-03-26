module Admin
  class NotificationsController < AdminController
    before_action :ensure_valid_notification_mean

    def create
      notification = building.notifications.create(
        notification_mean: notification_mean,
        state: :enqueued,
        enqueued_at: DateTime.current
      )

      DeliverNotificationJob.perform_now notification

      redirect_to admin_root_path
    end

    private

      def ensure_valid_notification_mean
        unless valid_notification_mean_is_present?
          redirect_to admin_root_path and return
        end
      end

      def building
        Building.find params[:building_id]
      end

      def notification_mean
        params[:mean_of_notification]
      end

      def valid_notification_mean_is_present?
        valid_notification_means.include? notification_mean
      end

      def valid_notification_means
        ["email", "letter"]
      end
  end
end
