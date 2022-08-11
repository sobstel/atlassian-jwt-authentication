# frozen_string_literal: true

module AtlassianJwtAuthentication
  class Railtie < Rails::Railtie
    rake_tasks do
      require "tasks/install"
    end
  end
end
