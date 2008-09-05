require File.expand_path(File.dirname(__FILE__) + "/lib/insert_routes.rb")

class ShopifyAppGenerator < Rails::Generator::Base
  
  PLUGIN_NAME = 'shopify_app'
  PLUGIN_DIR  = "vendor/plugins/#{PLUGIN_NAME}"
  
  attr_accessor :api_key, :secret
  
  def initialize(*runtime_args)
    super(*runtime_args)
    usage if args.size < 2
    
    @api_key = args[0]
    @secret = args[1]
  end
  
  def manifest
    controllers = ['login', 'dashboard']
    
    record do |m|
      # Create plugin structure
      m.directory PLUGIN_DIR

      # Copy init file to make it active when the plugin is loaded
      m.file "../lib/init.rb", "#{PLUGIN_DIR}/init.rb"
      
      # Check if this generator is called as a plugin already, then skip those 3 files
      unless File.exist?("#{RAILS_ROOT}/#{PLUGIN_DIR}/lib")
        m.directory "#{PLUGIN_DIR}/lib"

        # ShopifyAPI file
        m.file "../lib/shopify_api.rb", "#{PLUGIN_DIR}/lib/shopify_api.rb"
      
        # Shopify controller mixin
        m.file "../lib/shopify_login_protection.rb", "#{PLUGIN_DIR}/lib/shopify_login_protection.rb"
      end
      
      # Shopify config file
      m.template 'config/shopify.yml', 'config/shopify.yml'
      
      # Controllers
      m.file "controllers/login_controller.rb", "app/controllers/login_controller.rb"
      
      unless @options[:controller_only]
        m.file "controllers/dashboard_controller.rb", "app/controllers/dashboard_controller.rb" 

        # Helpers
        controllers.each do |name| 
          m.file "helpers/#{name}_helper.rb", "app/helpers/#{name}_helper.rb"
        end

        # Views
        controllers.each do |name| 
          m.directory "app/views/#{name}"
          m.file "views/#{name}/index.html.erb", "app/views/#{name}/index.html.erb"
        end
        m.file "views/dashboard/welcome.html.erb", "app/views/dashboard/welcome.html.erb"

        %w[order product article].each do |resource|
          m.file "views/dashboard/_#{resource}.html.erb", "app/views/dashboard/_#{resource}.html.erb"
        end
      
        # Layouts
        m.file "views/layouts/application.html.erb", "app/views/layouts/application.html.erb"

        # CSS 
        m.file 'stylesheets/application.css', 'public/stylesheets/application.css'
      
      end

      # delete public/index.html
      File.delete "#{RAILS_ROOT}/public/index.html" if File.exist?("#{RAILS_ROOT}/public/index.html")
      
      # Routes
      m.route 'connect', '/login/:action', { :controller => 'login' }

      if @options[:controller_only]
        m.route 'connect', '', { :controller => 'login' }
      else
        m.route 'connect', '', { :controller => 'dashboard', :action => 'welcome' }
        m.route 'connect', '/dashboard/:action/:blog/:article', { :controller => 'dashboard'}
      end
      
      # Display Readme
      m.readme '../README'
    end
  end
  
  
protected

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--controller-only", "Generate only the login controller and no views at all.") { |v| options[:controller_only] = v }
    opt.on("--do-nothing", "Don't generate anything at all.") { |v| options[:do_nothing] = v }
  end

  def banner
    <<-EOS
Creates a login controller and a dashboard controller showing basic information about a shop.

USAGE: #{$0} #{spec.name} API_Key Secret [options]
EOS
  end
  
end
