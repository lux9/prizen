class ProductsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if params[:query].present?
      sql_query = "name ILIKE :query"
      # sql_query = "name ILIKE :query OR synopsis ILIKE :query"
      @products = Product.where(sql_query, query: "%#{params[:query]}%").where.not(actual_price: 0).order(actual_price: :asc)
    else
      @products = Product.where.not(actual_price: 0).order(actual_price: :asc)
    end
  end

  def refresh_puppis
    Product.destroy_all

    puts Product.count

    def verify(p)
      product = Product.find_by(name: p[:name])
      if product
      elsif product.nil?
        product = Product.new(pic_link: p[:img_url], name: p[:name], actual_price: p[:price], link: p[:link])
        product.save!
        puts "NEW product"
      else
        puts 'nothing'
      end
    end

    require "open-uri"
    require "nokogiri"
    html_doc = ""
    page = 0

    while html_doc != []

      url = "https://www.puppis.com.ar/buscapagina?fq=H%3a4245&PS=24&sl=ef3fcb99-de72-4251-aa57-71fe5b6e149f&cc=24&sm=0&PageNumber=#{page}"
      p page

      html_file = URI.open(url).read
      html_doc = Nokogiri::HTML(html_file)
      puts '>'
      products = html_doc.search(".product")
      break if products.count.zero?
      products.each_with_index do |pro, i|
        img = pro.search("span").first.search("img").first.attributes["src"].value

        product = pro.find('.productListInfo').first
        brand = pro.search(".brand").first.search("a").first.content

        price = pro.search(".bestPrice").first.content.split.last.gsub(".", "").to_i

        anchor = pro.search("a").last
        link = anchor["href"]
        name = anchor.search("span").first.content

        prod = {brand: brand, price: price, link: link, name: name, img_url: img}
        verify(prod)
      end

      page += 1
      puts Product.count

    end

    puts Product.count


    redirect_to products_path
  end

  def refresh
    redirect_to products_path
  end

end
