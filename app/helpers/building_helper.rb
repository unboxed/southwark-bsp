module BuildingHelper
  def last_letter(building)
    return if building.notifications.where(notification_mean: "letter").blank?

    building.notifications.where(notification_mean: "letter")
            .last.sent_at
  end

  def last_email(building)
    return if building.notifications.where(notification_mean: "email").blank?

    building.notifications.where(notification_mean: "email")
            .last.sent_at
  end
end
