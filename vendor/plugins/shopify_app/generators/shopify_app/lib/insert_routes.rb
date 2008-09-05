# Stolen from http://github.com/technoweenie/restful-authentication/tree/master/generators/authenticated/lib
# Modified by Dennis Theisen
# Thanks a lot !
Rails::Generator::Commands::Create.class_eval do
  def route(name, path, options = {})
    sentinel = 'ActionController::Routing::Routes.draw do |map|'
    
    cmd = "map.#{name} '#{path}', :controller => '#{options[:controller]}'"
    cmd << ", :action => '#{options[:action]}'" if options[:action]
    
    logger.route(cmd)
    unless options[:pretend]
      gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n#{cmd}"
      end
    end
  end
end
 
Rails::Generator::Commands::Destroy.class_eval do
  def route(name, path, options = {})
    cmd = "map.#{name} '#{path}', :controller => '#{options[:controller]}'"
    cmd << ", :action => '#{options[:action]}'" if options[:action]
    
    look_for = "\n #{cmd}"
    logger.route(cmd)
    gsub_file 'config/routes.rb', /(#{look_for})/mi, ''
  end
end
 
Rails::Generator::Commands::List.class_eval do
  def route(name, path, options = {})
    cmd = "map.#{name} '#{path}', :controller => '#{options[:controller]}'"
    cmd << ", :action => '#{options[:action]}'" if options[:action]
    
    logger.route(cmd)
  end
end