# frozen_string_literal: true

require 'test_helper'

class ProductControllerTest < ActionDispatch::IntegrationTest
  test 'Render list all products' do
    get products_path
    assert_response :success
    assert_select '.product', 2
  end

  test 'Render product details' do
    get product_path(products(:one))
    assert_response :success
    assert_select '.product', 1
  end

  test 'Render new product form' do
    get new_product_path
    assert_response :success
    assert_select 'form', 1
  end

  test 'Create new product' do
    assert_difference 'Product.count', 1 do
      post products_path, params: {
        product: {
          title: 'New Product', description: 'New Product Description', price: 100
        }
      }
    end
    assert_redirected_to product_path(Product.last)
    assert_equal flash[:notice], 'Product created successfully'
  end

  test 'Create new product with invalid data' do
    assert_no_difference 'Product.count' do
      post products_path, params: { product: { title: '', description: '', price: '' } }
    end
    assert_response :unprocessable_entity
    assert flash[:alert].present?
  end

  test 'Render edit product form' do
    get edit_product_path(products(:one))
    assert_response :success
    assert_select 'form', 1
  end

  test 'Update product' do
    product = products(:one)
    patch product_path(product), params: { product: { title: 'Updated Product' } }
    assert_redirected_to product_path(product)
    assert_equal flash[:notice], 'Product updated successfully'
  end

  test 'Update product with invalid data' do
    product = products(:one)
    patch product_path(product), params: { product: { title: '' } }
    assert_response :unprocessable_entity
    assert flash[:alert].present?
  end

  test 'Can delete product' do
    assert_difference 'Product.count', -1 do
      delete product_path(products(:one))
    end
    assert_redirected_to products_path
    assert_equal flash[:notice], 'Product deleted successfully'
  end
end
