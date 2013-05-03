require 'sinatra/base'

module Sinatra
  module SampleApp
    module Routing
      module Main

        def self.registered(app)

          app.get "/" do
            redirect "/accounts"
          end

        end

      end
    end
  end
end
