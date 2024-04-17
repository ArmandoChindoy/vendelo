# frozen_string_literal: true

# Description: This is the model for the category table in the database.
class Category < ApplicationRecord
  has_many :products, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :name, uniqueness: true

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      all
    end
  end

  def self.sort(sort)
    order(name: sort)
  end
end
