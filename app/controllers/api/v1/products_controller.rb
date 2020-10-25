module Api
  module V1
    class ProductsController < ApplicationController
      include Rails.application.routes.url_helpers
      before_action :set_product, only: [:show, :update, :destroy]
    
      # GET /products
      def index
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
          if Rails.env.production?
            result_image = Cloudinary::Uploader.upload(params[:image_file][:image], :folder => "artykrea/") 
            @product.update(image_url: result_image['secure_url'])
          else  
            @product.update(image: params[:image_file][:image])
            @product.update(image_url: rails_blob_url(@product.image))  
          end
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
          params.require(:product).permit(:name, :description, :price, :qty, :published, :category_id, :image_url, :image)
        end
    end
  end
end
