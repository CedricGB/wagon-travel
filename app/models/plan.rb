class Plan < ApplicationRecord
  belongs_to :user, :chat, dependent: :destroy
  has_many :transports, :activities, :logements, dependent: :destroy
  validates :departure, :arrival, :title, :date_start, :date_end, presence: true
end
