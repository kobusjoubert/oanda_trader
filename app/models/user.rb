class User < ApplicationRecord
  has_many :accounts, dependent: :destroy

  # Include default devise modules. Others available are:
  # :omniauthable, :confirmable
  devise :invitable, :registerable, :database_authenticatable, :lockable, :timeoutable, :recoverable, :rememberable, :trackable, :validatable

  def to_s
    display_name || email
  end

  def current_account
    accounts.current.last
  end
end
