require 'support/api_helper'

RSpec.describe do
  let(:importer_runs) { FactoryGirl.create :importer_run }

  before(:each) do
    Rails.cache.clear
    importer_runs.update_attributes(destination_model: 'cache:warm')
  end

  describe 'GET /importers' do
    context 'when logged out' do
      it 'returns a 401', skip: true do
        get '/monitoring/importers'
        expect(last_response.status).to eql(401)
      end
    end

    context 'with basic auth' do
      it 'returns a 200', skip: true do
        get '/monitoring/importers', nil, basic_auth
        expect(last_response.status).to eql(200)
      end

      it 'returns all alerts', skip: true do
        get '/monitoring/importers', nil, basic_auth
        response_body = JSON.parse(last_response.body)
        expect(response_body[0]['ip']).to eql(importer_runs.source_model)
        expect(response_body[0]['nagios_alerts'][0].keys).to eql(['cache:warm'])
      end
    end
  end

  describe 'GET /importers/:id' do
    context 'when logged out' do
      it 'returns a 401', skip: true do
        get '/monitoring/importers/:id'
        expect(last_response.status).to eql(401)
      end
    end

    context 'with basic auth' do
      context 'with bad id' do
        it 'returns a 404', skip: true do
          get '/monitoring/importers/bad_id', nil, basic_auth
          expect(last_response.status).to eql(404)
        end
      end

      context 'with good id' do
        it 'returns a 200', skip: true do
          get "/monitoring/importers/#{importer_runs.source_model}", nil, basic_auth
          expect(last_response.status).to eql(200)
        end

        it 'returns the alert', skip: true do
          get "/monitoring/importers/#{importer_runs.source_model}", nil, basic_auth
          response_body = JSON.parse(last_response.body)
          expect(response_body['ip']).to eql(importer_runs.source_model)
          expect(response_body['nagios_alerts'][0].keys).to eql(['cache:warm'])
        end
      end
    end
  end
end
