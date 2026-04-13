class Transport < ApplicationRecord
  belongs_to :plan, dependent: :destroy
end
