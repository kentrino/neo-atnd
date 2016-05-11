# frozen_string_literal: true

module EventsHelper
  def get_user_links(users)
    users.map do |u|
      link_to u.name, user_path(u)
    end.join(' ').html_safe
  end
end
