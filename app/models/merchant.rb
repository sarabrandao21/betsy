class Merchant < ApplicationRecord
    has_many :products

    validates :username, uniqueness: true, presence: true
    validates :email, uniqueness: true, presence: true
end
