module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: [:show, :update, :destroy]
    
      # GET /products
      def index
        
        # binding.pry
        
        category_params = params[:type]
        @products = category_params == 'productos' ? Product.all : Category.find_by(name: category_params).products
    
        render json: @products
      end
    
      # GET /products/1
      def show
        render json: @product
      end
    
      # POST /products
      def create
        @product = Product.new(product_params)
    
        if @product.save
          render json: @product, status: :created
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end
    
      # PATCH/PUT /products/1
      def update
        if @product.update(product_params)
          render json: @product
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end
    
      # DELETE /products/1
      def destroy
        @product.destroy
      end
    
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_product
          @product = Product.find(params[:id])
        end
    
        # Only allow a trusted parameter "white list" through.
        def product_params
          params.require(:product).permit(:name, :description, :price, :qty, :published, :category_id, :image)
        end
    end
  end
end
