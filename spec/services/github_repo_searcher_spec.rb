# frozen_string_literal: true

RSpec.describe(GithubRepoSearcher) do
  describe('.call') do
    subject { described_class.new(search_params, github_token) }
    let(:search_params) { 'rails' }
    let(:github_token) { 'github_token' }

    context 'successful cases' do
      let(:results) { [{ name: 'name' }] }
      let(:client_double) { instance_double('GithubClient', successful?: true, results: results) }
      let(:results) { { total_count: 1, items: [{}] } }

      it 'calls client with proper params', aggregate_failures: true do
        expect(GithubClient)
          .to receive(:new).with('/search/repositories?q=rails', github_token).and_return(client_double)
        expect(client_double).to receive(:successful?)

        subject.call
      end

      context 'when client successful' do
        before do
          allow(subject).to receive(:client).and_return(client_double)
        end
        it 'returns proper results' do
          expect(subject.call).to be_a(SearchResult)
          expect(subject.call.data).to eq(results)
        end
      end
    end

    context 'failure cases' do
      let(:error) { 'errosr' }
      let(:client_double) { instance_double('GithubClient', successful?: false, error: error) }
      let(:results) { { total_count: 1, items: [{}] } }
      it 'calls client with proper params', aggregate_failures: true do
        expect(GithubClient)
          .to receive(:new).with('/search/repositories?q=rails', github_token).and_return(client_double)
        expect(client_double).to receive(:successful?)

        subject.call
      end

      context 'when client is not successful' do
        before do
          allow(subject).to receive(:client).and_return(client_double)
        end
        it 'returns proper results' do
          expect(subject.call).to be_a(SearchResult)
          expect(subject.call.error).to eq(error)
        end
      end
    end
  end
end
