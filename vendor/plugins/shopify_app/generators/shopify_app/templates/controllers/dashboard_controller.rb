class DashboardController < ApplicationController
  
  around_filter :shopify_session, :except => 'welcome'
  
  def index
    @products = ShopifyAPI::Product.find(:all)
    @orders   = ShopifyAPI::Order.find(:all, :params => {:limit => 5})

    @articles = []
    @blogs = ShopifyAPI::Blog.find(:all)
    # Get recent articles from each blog
    @blogs.each do |blog|
      @articles += ShopifyAPI::Article.find(:all, :params => {:blog_id => blog.id}, :limit => 5)
    end
    # Truncate to only the latest 5 articles
    @articles = @articles.sort_by(&:updated_at)[0..4].reverse
  end
  
  def welcome
  end
  
end