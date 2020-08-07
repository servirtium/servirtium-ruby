# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Servirtium::ServirtiumServlet do
  subject(:servlet) { described_class }

  let(:request) { instance_double(WEBrick::HTTPRequest) }
  let(:response) { WEBrick::HTTPResponse.new WEBrick::Config::HTTP }
  let!(:server) { class_double('Servirtium::DemoServer') }
  context 'playback' do
    it 'responds with a default response' do
      Servirtium.example = 'test_example'
      Servirtium.interaction = 0
      expect(server).to receive(:[]).with(:Logger)
      servlet = Servirtium::ServirtiumServlet.new(server)

      expect(servlet).not_to be nil
      expect(servlet.service(request, response)).not_to be nil
      expect(response.status).to eq 200
    end
  end

  context 'record' do
    let!(:faraday) { class_double('Faraday') }
    let(:header) do
      {
        'accept-encoding' => ['gzip;q=1.0,deflate;q=0.6,identity;q=0.3'],
        'accept' => ['*/*'],
        'connection' => []
      }
    end
    let(:headers) do
      {
        'content-type' => 'application/xml',
        'connection' => 'keep-alive',
        'access-control-allow-origin' => '*',
        'access-control-allow-headers' => 'X-Requested-With',
        'access-control-allow-methods' => 'GET',
        'strict-transpor-security' => '',
        'content-security-policy' => "default-src 'self'",
        'cache-control' => 'no-cache,no-store',
        'secure' => 'true',
        'httponly' => 'true',
        'transfer-encoding' => 'chunked'
      }
    end
    # rubocop:disable Layout/LineLength
    let(:body) do
      {
        'list' => {
          'domain.web.AnnualGcmDatum' => [
            { 'gcm' => 'bccr_bcm2_0', 'variable' => 'pr', 'fromYear' => '1980', 'toYear' => '1999', 'annualData' => { 'double' => '987.9504418944' } },
            { 'gcm' => 'cccma_cgcm3_1', 'variable' => 'pr', 'fromYear' => '1980', 'toYear' => '1999', 'annualData' => { 'double' => '815.2627636718801' } },
            { 'gcm' => 'cnrm_cm3', 'variable' => 'pr', 'fromYear' => '1980', 'toYear' => '1999', 'annualData' => { 'double' => '1099.3898999037601' } },
            { 'gcm' => 'csiro_mk3_5', 'variable' => 'pr', 'fromYear' => '1980', 'toYear' => '1999', 'annualData' => { 'double' => '1021.6996069333198' } },
            { 'gcm' => 'gfdl_cm2_0', 'variable' => 'pr', 'fromYear' => '1980', 'toYear' => '1999', 'annualData' => { 'double' => '1019.8750146478401' } },
            { 'gcm' => 'gfdl_cm2_1', 'variable' => 'pr', 'fromYear' => '1980', 'toYear' => '1999', 'annualData' => { 'double' => '1084.5603759764' } },
            { 'gcm' => 'ingv_echam4', 'variable' => 'pr', 'fromYear' => '1980', 'toYear' => '1999', 'annualData' => { 'double' => '1008.2985131833999' } },
            { 'gcm' => 'inmcm3_0', 'variable' => 'pr', 'fromYear' => '1980', 'toYear' => '1999', 'annualData' => { 'double' => '1194.9564575200002' } },
            { 'gcm' => 'ipsl_cm4', 'variable' => 'pr', 'fromYear' => '1980', 'toYear' => '1999', 'annualData' => { 'double' => '893.9680444336799' } },
            { 'gcm' => 'miroc3_2_medres', 'variable' => 'pr', 'fromYear' => '1980', 'toYear' => '1999', 'annualData' => { 'double' => '1032.85460449136' } },
            { 'gcm' => 'miub_echo_g', 'variable' => 'pr', 'fromYear' => '1980', 'toYear' => '1999', 'annualData' => { 'double' => '905.9324633786798' } },
            { 'gcm' => 'mpi_echam5', 'variable' => 'pr', 'fromYear' => '1980', 'toYear' => '1999', 'annualData' => { 'double' => '1024.2805590819598' } },
            { 'gcm' => 'mri_cgcm2_3_2a', 'variable' => 'pr', 'fromYear' => '1980', 'toYear' => '1999', 'annualData' => { 'double' => '784.5488305664002' } },
            { 'gcm' => 'ukmo_hadcm3', 'variable' => 'pr', 'fromYear' => '1980', 'toYear' => '1999', 'annualData' => { 'double' => '957.3522631840398' } },
            { 'gcm' => 'ukmo_hadgem1', 'variable' => 'pr', 'fromYear' => '1980', 'toYear' => '1999', 'annualData' => { 'double' => '1001.7526196294' } }
          ]
        }
      }
    end
    # rubocop:enable Layout/LineLength

    before do
      Servirtium.record = true
      Servirtium.domain = 'http://climatedataapi.worldbank.org'
    end

    it 'responds with a default response' do
      Servirtium.example = 'test_example'
      Servirtium.interaction = 0

      expect(server).to receive(:[]).with(:Logger)

      expect(request).to receive(:path).at_least(:once).and_return 'annualavg/pr/1980/1999/egy.xml'
      expect(request).to receive(:request_method).at_least(:once).and_return 'GET'
      expect(request).to receive(:header).at_least(:once).and_return header

      expect(response).to receive(:headers).at_least(:once).and_return headers
      expect(response).to receive(:body).at_least(:once).and_return body

      connection = instance_double('Faraday::Connection')
      expect(Faraday).to receive(:new).and_return connection
      expect(connection).to receive(:get).with('annualavg/pr/1980/1999/egy.xml').and_return response

      servlet = Servirtium::ServirtiumServlet.new(server)

      expect(servlet).not_to be nil
      expect(servlet.service(request, response)).not_to be nil
      expect(response.status).to eq 200
    end
  end
end
