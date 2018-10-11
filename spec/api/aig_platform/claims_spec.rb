# require 'support/api_helper'

# RSpec.describe DashboardPlatform::API do
#   before(:each) do
#     Rails.cache.clear
#   end

#   describe 'GET /api/claims' do
#     context 'when logged out' do
#       it 'returns a 200' do
#         get '/api/claims'
#         expect(last_response.status).to eql(200)
#       end

#       it 'returns an empty array' do
#         get '/api/claims'
#         response_body = JSON.parse(last_response.body)
#         expect(last_response.body).to eql({claims:[]}.to_json)
#       end
#     end

#     context 'when logged in' do
#       context 'with no claims' do
#         include_context 'logged in with privileges'

#         it 'returns a 200' do
#           get '/api/claims'
#           expect(last_response.status).to eql(200)
#         end

#         it 'returns an empty array' do
#           get '/api/claims'
#           response_body = JSON.parse(last_response.body)
#           expect(last_response.body).to eql({claims:[]}.to_json)
#         end

#       end

#       context 'with_claims' do
#         include_context 'logged in with privileges'
#         include_context 'with valid features and associations'

#         it 'returns an array of claims' do
#           get '/api/claims'
#           response = JSON.parse(last_response.body)

#           expect(response).to have_key('claims')
#           expect(response['claims']).to be_an(Array)
#           expect(response['claims'].length).to eql(1)
#           expect(response['claims'].first['id']).to eql(claim.id)
#           expect(response['claims'].first['id']).to eql(claim.id)
#         end
#       end

#     end
#   end
# end
