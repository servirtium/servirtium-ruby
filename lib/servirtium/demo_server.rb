# frozen_string_literal: true

require 'rdoc'
require 'webrick'

module Servirtium
  class DemoServer
    def initialize(port)
      @server = WEBrick::HTTPServer.new(Port: port)

      @server.mount '/', ServirtiumServlet

      trap('INT') do
        @server.shutdown
      end
    end

    def start
      @server.start
    end

    def stop
      @server.shutdown
    end
  end
end
