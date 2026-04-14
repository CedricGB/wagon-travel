class Plan < ApplicationRecord
  belongs_to :user
  has_one :chat, dependent: :destroy
  has_many :transports, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :logements, dependent: :destroy
  validates :departure, :arrival, :title, :date_start, :date_end, presence: true
end
