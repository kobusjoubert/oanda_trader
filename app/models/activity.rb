class Activity < ApplicationRecord
  belongs_to :user_strategy

  enum level: [:default, :success, :info, :warning, :danger, :primary, :secondary, :light, :dark]
  enum position: [:long, :short]
  enum action: [:filled, :closed, :created, :cancelled, :opened, :triggered, :reduced]

  scope :positions, -> { where.not(position: nil) }
  scope :default,   -> { where('level = 0 OR level IS NULL') }
  scope :color,     -> { where('level > 0') }
end
