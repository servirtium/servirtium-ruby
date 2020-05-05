# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Servirtium::ServirtiumServlet do
  subject(:servlet) { described_class }

  let(:request) { WEBrick::HTTPRequest.new WEBrick::Config::HTTP }
  let(:response) { WEBrick::HTTPResponse.new WEBrick::Config::HTTP }
  let!(:server) { class_double('Servirtium::DemoServer') }

  it 'responds with a default response' do
    Servirtium.example = 'test_example'
    Servirtium.interaction = 0
    expect(server).to receive(:[]).with(:Logger)
    servlet = Servirtium::ServirtiumServlet.new(server)

    expect(servlet).not_to be nil
    expect(servlet.do_GET(request, response)).not_to be nil
  end
end
