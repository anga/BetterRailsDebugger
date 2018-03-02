module BetterRailsDebugger
  module ApplicationHelper
    def order_link(title, column, object)
      order = params[:order].to_s == 'asc' ? 'desc' : 'asc'
      link_class = params[:column] == column ? "text-primary" : "text-light"
      if object.kind_of? GroupInstance
        link_to title, objects_group_instance_url(object, column: column, order: order), class: link_class
      else
        title
      end
    end
  end
end
