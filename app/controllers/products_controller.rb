# frozen_string_literal: true

# ProductsController handles actions related to Product in the application.
class ProductsController < ApplicationController
  def index
    @categories = Category.order(name: :asc).load_async

    @products = Product.with_attached_photo.where(
            [
            params[:min_price].present? ? "price >= #{params[:min_price]}" : nil,
            params[:max_price].present? ? "price <= #{params[:max_price]}" : nil,
            params[:category_id].present? ? "category_id = #{params[:category_id]}" : nil,
            ].compact.join(" AND ")
        )
    if params[:query_text].present?
      @products = @products.search_full_text(params[:query_text])
    end

    if params[:order_by].present?
      order_by = Product::ORDER_BY.fetch(params[:order_by]&.downcase.to_sym, Product::ORDER_BY[:newest])
      
      @products = @products.order(order_by).load_async
    end

    @pagy, @products = pagy_countless(@products, items: 12)
  end

  def show
    current_product
  end

  def new
    @product = Product.new
  end

  def edit
    current_product
  end

  def create
    product = Product.new(product_params)
    if product.save
      flash[:notice] = t('.created')
      redirect_to product_path(product)
    else
      notice = product.errors.full_messages.join(', ')
      flash[:alert] = notice
      render :new, status: :unprocessable_entity
    end
  end

  def update
    product_to_update = current_product
    if product_to_update.update(product_params)
      flash[:notice] = t('.updated')
      redirect_to product_path(product_to_update)
    else
      notice = product_to_update.errors.full_messages.join(', ')
      flash[:alert] = notice
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_product.destroy

    flash[:notice] = t('.destroyed')
    redirect_to products_path , status: :see_other
  end

  private

  def current_product
    @product ||= Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :photo, :description, :price, :category_id)
  end
end
