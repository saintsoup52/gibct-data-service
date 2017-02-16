# frozen_string_literal: true
module ApplicationHelper
  def active_link?(path, method = 'GET')
    begin
      h = Rails.application.routes.recognize_path(path, method: method)
    rescue ActionController::RoutingError
      return false
    end

    controller.controller_name == h[:controller] && controller.action_name == h[:action]
  end

  def li_active_class(path, method = 'GET')
    active_link?(path, method) ? 'active' : ''
  end

  def link_if_not_active(body, path, method = 'GET')
    active_link?(path, method) ? safe_join(["<a>#{body}</a>".html_safe]) : link_to(body, path)
  end

  # Wraps an array of error messages in an html list with a label (optional) above it
  def pretty_error(errors, label = '')
    return '' if errors.blank?

    content_tag(:div, class: 'errors') do
      concat(content_tag(:p, label)) if label.present?

      concat(
        content_tag(:ul) do
          errors.map do |error|
            concat content_tag(:li, error)
          end
        end
      )
    end
  end
end
