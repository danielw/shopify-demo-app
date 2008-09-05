require 'shopify_api'
require 'shopify_login_protection'

ShopifyAPI::Session.setup(YAML.load_file("#{RAILS_ROOT}/config/shopify.yml")[RAILS_ENV])


ActionController::Base.send :include, ShopifyLoginProtection
ActionController::Base.send :helper_method, :current_shop

