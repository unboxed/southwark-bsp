class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable, :recoverable, :trackable

  def first_name
    name.to_s.split(/\s+/).first
  end
end
