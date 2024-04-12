# frozen_string_literal: true

# ProductsController handles actions related to Product in the application.
class ProductsController < ApplicationController
  def index
    @products ||= Product.all
  end

  def show
    current_product
  end

  def new
    Product.new
  end

  def edit
    current_product
  end

  def create
    product = Product.new(product_params)
    if product.save
      flash[:notice] = 'Product created successfully'
      redirect_to product_path(product)
    else
      notice = product.errors.full_messages.join(', ')
      flash[:alert] = notice
      render :new, status: :unprocessable_entity
    end
  end

  def update
    product_to_update = current_product
    if product.update(product_params)
      flash[:notice] = 'Product updated successfully'
      redirect_to product_path(product)
    else
      notice = product.errors.full_messages.join(', ')
      flash[:alert] = notice
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_product.destroy
    flash[:notice] = 'Product deleted successfully'
    redirect_to products_path
  end

  private

  def current_product
    @product ||= Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :photo, :description, :price)
  end
end
