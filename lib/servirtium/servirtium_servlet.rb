# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'gyoku'
require 'rdoc'
require 'webrick'

module Servirtium
  class << self
    attr_accessor :domain, :example, :interaction, :record, :pretty_print
  end

  class ServirtiumServlet < WEBrick::HTTPServlet::AbstractServlet
    def service(request, response)
      @responses ||= []
      # TODO: cater for JSON and other non-XML types
      response.content_type = 'application/xml'
      response.status = 200
      response.body = default_response

      record_new_response Servirtium.example, request if Servirtium.record

      playback_file = find_playback_file_for Servirtium.example
      response.body = retrieve_body_from playback_file if playback_file

      response
    end

    # TODO: do_POST and more

    private

    def default_response
      "No playback file was found for #{Servirtium.example}"
    end

    def record_new_response(example_path, request)
      filepath = playback_filepath example_path
      f = if Servirtium.interaction.zero?
            File.new(filepath, 'w')
          else
            File.new(filepath, 'a')
          end
      f.write(build_recording(request))
      f.close
    end

    def find_playback_file_for(example_path)
      filepath = playback_filepath example_path
      return filepath if File.exist? filepath

      raise StandardError, "File [#{filepath}] not found"
    end

    def playback_filepath(example_path)
      "spec/lib/mocks/#{example_path}.md"
    end

    def retrieve_body_from(playback_file)
      markdown_file = File.read(playback_file)
      doc = RDoc::Markdown.parse(markdown_file)
      parse_responses(doc)
      response = @responses[Servirtium.interaction].parts.first
      Servirtium.interaction = Servirtium.interaction + 1
      response
    rescue StandardError => _e
      raise
    end

    def parse_responses(doc)
      @responses = []
      take_next = false
      doc.entries.each do |entry|
        @responses << entry if take_next
        take_next = entry.text.start_with? 'Response body recorded for playback'
      end
    end

    def build_recording(request)
      response = make_request(request)
      <<~RECORDING
        #{build_interaction_from request}

        #{build_request_headers_from request}

        #{build_request_body}

        #{build_response_headers_from response}

        #{build_response_body_from response}
      RECORDING
    end

    def make_request(request)
      method_name = request.request_method.gsub(/-/, '_').downcase
      url = Servirtium.domain
      connection = Faraday.new url do |conn|
        conn.response :xml, content_type: /\bxml$/
        conn.adapter Faraday.default_adapter
      end
      connection.send(method_name, *request.path)
    end

    def build_interaction_from(request)
      "## Interaction #{Servirtium.interaction}: #{request.request_method} #{request.path}"
    end

    def build_request_headers_from(request)
      <<~HEADERS
        ### Request headers recorded for playback:

        ```
        Host: #{Servirtium.domain.split('//').last}
        User-Agent: Servirtium
        Accept-Encoding: #{request.header['accept-encoding']}
        Accept: #{request.header['accept']}
        Connection: #{request.header['connection']}
        ```
      HEADERS
    end

    def build_request_body
      <<~BODY
        ### Request body recorded for playback ():

        ```


        ```
      BODY
    end

    # rubocop:disable Metrics/AbcSize
    def build_response_headers_from(response)
      # TODO: 'transport' in the below?
      <<~HEADERS
        ### Response headers recorded for playback:

        ```
        Content-Type: #{response.headers['content-type']}
        Connection: #{response.headers['connection']}
        Access-Control-Allow-Origin: #{response.headers['access-control-allow-origin']}
        Access-Control-Allow-Headers: #{response.headers['access-control-allow-headers']}
        Access-Control-Allow-Methods: #{response.headers['access-control-allow-methods']}
        Strict-Transport-Security: #{response.headers['strict-transpor-security']}
        Content-Security-Policy: #{response.headers['content-security-policy']}
        Cache-Control: #{response.headers['cache-control']}
        Secure: #{response.headers['secure']}
        HttpOnly: #{response.headers['httponly']}
        Transfer-Encoding: #{response.headers['transfer-encoding']}
        ```
      HEADERS
    end

    # rubocop:enable Metrics/AbcSize

    def build_response_body_from(response)
      response_body = if response.body.is_a? Hash
                        Gyoku
                          .xml(response.body, pretty_print: Servirtium.pretty_print)
                          .gsub('xsi:nil="true"', '')
                        # TODO: other types? XML, TXT?
                      else
                        response.body
                      end

      <<~BODY
        ### Response body recorded for playback (200: application/xml):

        ```
        #{response_body}
        ```
      BODY
    end
  end
end
