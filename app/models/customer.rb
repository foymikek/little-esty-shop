class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name

  has_many :invoices, dependent: :destroy
  has_many :merchants, through: :invoices
  has_many :transactions, through: :invoices
end
