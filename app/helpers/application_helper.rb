# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Create a tab as <li> and give it the id "current" if the current action matches that tab
  def tab(name, label = name.to_s.capitalize, highlight = /#{name}/i)
    if controller.action_name =~ highlight
      content_tag :li, link_to(label, {:action => "#{name.to_s}"}, {:id => "current"})
    else
      content_tag :li, link_to(label, :action => "#{name.to_s}")
    end    
  end

end
