# string_literal: true

# Description: This file contains the Product model. It has a one-to-many relationship with the Review model.
class Product < ApplicationRecord
  has_one_attached :photo
  validates :title, presence: true
  validates :price, presence: true
  # has_many :reviews, dependent: :destroy

  def average_rating
    reviews.average(:rating).to_f
  end

  def positive_reviews
    reviews.where('rating > 3')
  end

  def negative_reviews
    reviews.where('rating <= 3')
  end

  def self.search(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      all
    end
  end

  def self.price_range(min, max)
    where('price >= ? AND price <= ?', min, max)
  end

  def self.price_min(min)
    where('price >= ?', min)
  end

  def self.price_max(max)
    where('price <= ?', max)
  end

  def self.price_sort(sort)
    order(price: sort)
  end

  def self.rating_sort(sort)
    joins(:reviews).group(:id).order("AVG(reviews.rating) #{sort}")
  end
end
