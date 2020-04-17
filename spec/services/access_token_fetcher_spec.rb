# frozen_string_literal: true

RSpec.describe(AccessTokenFetcher) do
  describe '.call' do
    subject { described_class.new('valid_code') }

    context 'successful cases' do
      let(:access_token) { 'valid_access_token' }
      let(:parsed_response) do
        { 'access_token' => access_token, 'token_type' => 'bearer', 'scope' => '' }
      end

      let(:response_double) { double(parsed_response: parsed_response) }
      before do
        allow(subject).to receive(:response).and_return(response_double)
      end
      it 'returns access token' do
        expect(subject.call).to eq(access_token)
      end
    end

    context 'failure cases' do
      context 'when environment variables are not set' do
        let(:client_id) { 'CLIENT_ID' }
        let(:client_secret) { 'CLIENT_SECRET' }

        context 'CLIENT_ID' do
          before { ENV['CLIENT_ID'] = nil }
          after { ENV['CLIENT_ID'] = client_id }

          it 'raises proper error' do
            expect { subject.call }.to raise_error(ArgumentError, 'Set CLIENT_ID in the environment')
          end
        end

        context 'CLIENT_SECRET' do
          before { ENV['CLIENT_SECRET'] = nil }
          after { ENV['CLIENT_SECRET'] = client_secret }

          it 'raises proper error' do
            expect { subject.call }.to raise_error(ArgumentError, 'Set CLIENT_SECRET in the environment')
          end
        end
      end
      context 'when github return error' do
        let(:code) { 'invalid_code' }
        let(:access_token) { 'valid_access_token' }
        let(:parsed_response) do
          { 'error' => 'incorrect_client_credentials', 'error_description' => 'Description' }
        end

        let(:response_double) { double(parsed_response: parsed_response) }
        before do
          allow(subject).to receive(:response).and_return(response_double)
        end
        it 'retunrs nil' do
          expect(subject.call).to be_falsey
        end

        it 'logs error' do
          expect(Rails.logger).to receive(:error).with(parsed_response)

          subject.call
        end
      end
    end
  end
end
