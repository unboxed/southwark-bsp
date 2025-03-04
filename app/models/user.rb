class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable, :recoverable, :trackable

  def first_name
    name.to_s.split(/\s+/).first
  end

  def active_for_authentication?
    super && !deactivated?
  end

  def inactive_message
    deactivated? ? :deactivated : super
  end

  def deactivated?
    deactivated_at && deactivated_at.past?
  end
end
