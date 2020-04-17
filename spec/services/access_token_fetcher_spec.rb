# frozen_string_literal: true

RSpec.describe(AccessTokenFetcher) do
  describe '.call' do
    subject { described_class.new(code) }

    context 'successful cases' do
      let(:code) { 'valid_code' }
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
