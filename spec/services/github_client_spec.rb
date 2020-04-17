# frozen_string_literal: true

RSpec.describe(GithubClient) do
  describe '.successful?' do
    subject { described_class.new(search_path, github_token) }

    let(:response) { double(parsed_response: parsed_response, code: code) }
    let(:search_path) { '/search/path?q=search_term' }
    let(:github_token) { 'github_token' }

    before { allow(subject).to receive(:response).and_return(response) }

    context 'successful cases' do
      let(:item) { { name: "name" } }
      let(:parsed_response) { { total_count: 1, items: [item] } }
      let(:code) { 200 }

      it 'sets items to `results` property' do
        subject.successful?

        expect(subject.results).to eq(parsed_response)
      end

      it 'returns true' do
        expect(subject.successful?). to be_truthy
      end
    end

    context 'failure cases' do
      let(:item) { { name: "name" } }
      let(:message) { 'API rate limit exceeded for xxx.xxx.xxx.xxx.' }
      let(:parsed_response) do
        {
          "message": message,
          "documentation_url": "https://developer.github.com/v3/#rate-limiting"
        }
      end
      let(:code) { 403 }

      it 'sets items to `results` property' do
        subject.successful?

        expect(subject.error).to eq(message)
      end

      it 'returns true' do
        expect(subject.successful?). to be_falsey
      end
    end
  end
end
