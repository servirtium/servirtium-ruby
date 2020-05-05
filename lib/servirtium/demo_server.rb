# frozen_string_literal: true

require 'rdoc'
require 'webrick'

module Servirtium
  class << self
    attr_accessor :domain
    attr_accessor :example
    attr_accessor :interaction
  end

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
