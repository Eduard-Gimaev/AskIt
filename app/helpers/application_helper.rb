module ApplicationHelper

  def nav_tab(title, url, options = {})
    current_page = options.delete :current_page

    css_class = current_page == title ? 'active' : 'text-muted'

    options[:class] = if options[:class]
                        options[:class] + ' ' + css_class
                      else
                        css_class
                      end 
    
    link_to title, url, options
  end

  def currently_at(current_page = '')
    render partial: 'shared/main_menu', locals: { current_page: current_page }
  end

  def full_title(page_title = '')
    if page_title.empty?
      "AskIt"
    else
      page_title + " | AskIt"
    end
  end
end
