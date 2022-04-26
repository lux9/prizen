class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @products = Product.where.not(actual_price: 0).order(actual_price: :asc)
  end
end
