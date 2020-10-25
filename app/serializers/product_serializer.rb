class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :qty, :published, :image_url
  belongs_to :category
end
