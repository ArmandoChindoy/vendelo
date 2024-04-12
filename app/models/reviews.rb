# frozen_string_literal: true

# Reviews model
class Reviews < ActiveRecord::Base
  belongs_to :product
  belongs_to :user

  validates :rating, presence: true

  def self.search(search)
    if search
      where('content LIKE ?', "%#{search}%")
    else
      all
    end
  end

  def self.rating_sort(sort)
    order(rating: sort)
  end

  def self.user_sort(sort)
    order(user_id: sort)
  end

  def self.product_sort(sort)
    order(product_id: sort)
  end

  def self.rating_avg
    average(:rating).to_f
  end

  def self.rating_avg_product(product)
    where(product_id: product).average(:rating).to_f
  end

  def self.rating_avg_user(user)
    where(user_id: user).average(:rating).to_f
  end

  def self.rating_avg_user_product(user, product)
    where(user_id: user, product_id: product).average(:rating).to_f
  end
end
