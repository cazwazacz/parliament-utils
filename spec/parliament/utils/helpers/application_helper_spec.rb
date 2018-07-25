require 'spec_helper'

RSpec.describe Parliament::Utils::Helpers::ApplicationHelper do
  before(:all) do
    require 'pugin'
  end

  describe '#data_check' do
    # Create a dummy class that includes our module
    # Also, set up all methods etc needed for our test (these are overridden in each test)
    let(:dummy_class) do
      Class.new do
        include Parliament::Utils::Helpers::ApplicationHelper

        ROUTE_MAP ||= nil

        def request; end
        def params; end
        def response; end
        def redirect_to(_); end
      end
    end

    # Used for ROUTE_MAP
    let(:route_map) do
      {
        foo: proc do
          double(
            :request,
            query_url: 'https://api.parliament.uk/foo?bar=true&test=abc'
          )
        end
      }
    end

    # Stub a request object
    let(:request_formats) { ['application/json'] }
    let(:request_url) { 'https://localhost:3000/people/12345678' }
    let(:request) { double(:request, formats: request_formats, url: request_url) }

    # Stub a params object
    let(:params) { { action: 'foo' } }

    # Stub a response object
    let(:response) { double(:response, headers: {}) }

    # Instance of the dummy class
    let(:instance) { dummy_class.new }

    context 'with a URL that contains an extenstion' do
      let(:request_url) { 'https://localhost:3000/people/12345678.json?foo=true' }

      it 'redirects to the api url, including the extension' do
        dummy_class::ROUTE_MAP = route_map

        allow(instance).to receive(:request).and_return(request)
        allow(instance).to receive(:params).and_return(params)
        allow(instance).to receive(:response).and_return(response)
        allow(instance).to receive(:redirect_to).with('https://api.parliament.uk/foo.json?bar=true&test=abc').and_return(:as_expected)

        expect(instance.data_check).to eq(:as_expected)
      end
    end

    context 'with a URL that does not contain an extenstion' do
      it 'redirects to the api url' do
        dummy_class::ROUTE_MAP = route_map

        allow(instance).to receive(:request).and_return(request)
        allow(instance).to receive(:params).and_return(params)
        allow(instance).to receive(:response).and_return(response)
        allow(instance).to receive(:redirect_to).with('https://api.parliament.uk/foo?bar=true&test=abc').and_return(:as_expected)

        expect(instance.data_check).to eq(:as_expected)
      end
    end

    context '#title' do
      let(:helpers){ ActionController::Base.helpers }

      it 'will return the correct title' do
        expect(helpers.title('Test')).to eq('Test')
      end
    end

    before(:each) do
      Pugin.alternates = []
    end

    let(:alternates){[{ :type=>"application/n-triples", :href=>"https://api.parliament.uk/foo.nt?bar=true&test=abc"}, {:type=>"text/turtle", :href=>"https://api.parliament.uk/foo.ttl?bar=true&test=abc"}, {:type=>"text/tab-separated-values", :href=>"https://api.parliament.uk/foo.tsv?bar=true&test=abc"}, {:type=>"text/csv", :href=>"https://api.parliament.uk/foo.csv?bar=true&test=abc"}, {:type=>"application/json+rdf", :href=>"https://api.parliament.uk/foo.rj?bar=true&test=abc"}, {:type=>"application/json+ld", :href=>"https://api.parliament.uk/foo.json?bar=true&test=abc"}, {:type=>"application/rdf+xml", :href=>"https://api.parliament.uk/foo.xml?bar=true&test=abc"}]}

    context '#build_request' do
      it 'will return the correct alternate' do
        dummy_class::ROUTE_MAP = route_map

        allow(instance).to receive(:params).and_return(params)
        allow(Pugin).to receive(:alternates).and_return([])

        expect(instance.build_request).to eq(alternates)
      end
    end

    context '#populate_alternates' do
      it 'will populate Pugin.alternates' do
        dummy_class::ROUTE_MAP = route_map

        expect(Pugin.alternates).to eq([])

        instance.populate_alternates('https://api.parliament.uk/foo?bar=true&test=abc')

        expect(Pugin.alternates).to eq(alternates)
      end
    end

    context 'private' do
      context '#reset_alternatives' do
        before do
          Pugin.alternates = ['Test']
        end

        it 'will reset Pugin alternates' do
          expect(Pugin.alternates).to eq(['Test'])
          instance.send(:reset_alternates)
          expect(Pugin.alternates).to eq([])
        end
      end
    end
  end
end
