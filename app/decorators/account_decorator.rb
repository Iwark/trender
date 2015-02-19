# coding: utf-8
module AccountDecorator

  def linked_screen_name
    link_to "@#{screen_name}", "https://twitter.com/#{screen_name}", target:'_blank'
  end

  def colored_status
    color = {
      on:  "#444",
      off: "#888",
      error: "#f00"
    }
    content_tag 'span', status, style: "color:#{color[status.to_sym]}"
  end
end
