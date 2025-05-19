require "rails_helper"

RSpec.describe Browseable do
  let(:browseable) do
    Class.new do
      include Browseable

      def self.all
        self
      end
    end
  end

  describe "including the module" do
    it "adds a facet_definitions class attribute" do
      expect(browseable).to respond_to(:facet_definitions)
      expect(browseable.facet_definitions).to eq({})
    end
  end

  describe ".facet" do
    let(:scope) { -> { double(:scope) } }

    it "adds a facet scope to the facet_definitions class attribute" do
      browseable.facet(:exported, scope)
      expect(browseable.facet_definitions).to eq({ exported: scope })
    end
  end

  describe ".filter" do
    let(:filter) { -> { double(:filter) } }

    it "adds a filter scope to the filter_definitions class attribute" do
      browseable.filter(:city, filter)
      expect(browseable.filter_definitions).to eq({ city: filter })
    end
  end

  describe ".search" do
    let(:params) { {} }
    let(:search) { browseable.search(params) }

    it "returns an instance of Browseable::Search" do
      expect(search).to be_an_instance_of(Browseable::Search)
    end
  end

  describe Browseable::Search do
    let(:scopes)  { { all: -> { self }, exported: -> { self } } }
    let(:filters) { {} }
    let(:klass)   { double(:klass, facet_definitions: scopes, filter_definitions: filters, default_page_size: 50, max_page_size: 50) }
    let(:params)  { { q: "search", page: "3" } }
    let(:search)  { described_class.new(klass, params) }

    it "is enumerable" do
      expect(search).to respond_to(:each)
    end

    describe "delegated methods" do
      subject { search }

      it { is_expected.to delegate_method(:offset).to(:results) }
      it { is_expected.to delegate_method(:out_of_bounds?).to(:results) }
      it { is_expected.to delegate_method(:next_page).to(:results) }
      it { is_expected.to delegate_method(:previous_page).to(:results) }
      it { is_expected.to delegate_method(:total_entries).to(:results) }
      it { is_expected.to delegate_method(:total_pages).to(:results) }
      it { is_expected.to delegate_method(:to_a).to(:results) }
      it { is_expected.to delegate_method(:to_ary).to(:results) }
      it { is_expected.to delegate_method(:each).to(:to_a) }
      it { is_expected.to delegate_method(:map).to(:to_a) }
      it { is_expected.to delegate_method(:size).to(:to_a) }
    end

    describe "#empty?" do
      context "when total_entries is zero" do
        before do
          allow(search).to receive(:total_entries).and_return(0)
        end

        it "returns true" do
          expect(search.empty?).to be(true)
          expect(search).to have_received(:total_entries)
        end
      end

      context "when total_entries is not zero" do
        before do
          allow(search).to receive(:total_entries).and_return(1)
        end

        it "returns false" do
          expect(search.empty?).to be(false)
          expect(search).to have_received(:total_entries)
        end
      end
    end

    describe "#current_page" do
      it "returns the page number from the params" do
        expect(search.current_page).to eq(3)
      end

      context "when the page parameter is invalid" do
        let(:params) { { q: "search", page: "invalid" } }

        it "defaults to 1" do
          expect(search.current_page).to eq(1)
        end
      end

      context "when the page parameter is missing" do
        let(:params) { { q: "search" } }

        it "defaults to 1" do
          expect(search.current_page).to eq(1)
        end
      end
    end

    describe "#facets" do
      it "returns an instance of Browseable::Facets" do
        expect(search.facets).to be_an_instance_of(Browseable::Facets)
      end
    end

    describe "#first_page?" do
      context "when the current page is 1" do
        let(:params) { { q: "search", page: "1" } }

        it "returns true" do
          expect(search.first_page?).to be true
        end
      end

      context "when the current page is not 1" do
        let(:params) { { q: "search", page: "2" } }

        it "returns false" do
          expect(search.first_page?).to be false
        end
      end
    end

    describe "#last_page?" do
      context "when the current page is the same as the total pages" do
        let(:params) { { q: "search", page: "10" } }

        before do
          allow(search).to receive(:total_pages).and_return(10)
        end

        it "returns true" do
          expect(search.last_page?).to be true
          expect(search).to have_received(:total_pages)
        end
      end

      context "when the current page is not the same as the total pages" do
        let(:params) { { q: "search", page: "10" } }

        before do
          allow(search).to receive(:total_pages).and_return(20)
        end

        it "returns true" do
          expect(search.last_page?).to be false
          expect(search).to have_received(:total_pages)
        end
      end
    end

    describe "#previous_params" do
      let(:arel_table) { double(:arel_table) }
      let(:building)   { double(:building) }
      let(:buildings)  { [building] }
      let(:results)    { double(:results, to_a: buildings) }

      before do
        allow(arel_table).to receive(:[]).with("*").and_return("*")
        allow(klass).to receive(:basic_search).with("search").and_return(klass)
        allow(klass).to receive(:except).with(:select).and_return(klass)
        allow(klass).to receive(:arel_table).and_return(arel_table)
        allow(klass).to receive(:select).with("*").and_return(klass)
        allow(klass).to receive(:except).with(:order).and_return(klass)
        allow(klass).to receive(:paginate).with(page: 3, per_page: 50).and_return(results)
        allow(results).to receive_messages(to_a: buildings, previous_page: 2)
      end

      context "with default params" do
        it "returns a hash of params for building the previous page link" do
          expect(search.previous_params).to eq({ q: "search", page: 2 })
        end
      end

      context "with a custom state param" do
        let(:params) { { q: "search", page: "3", state: "exported" } }

        it "returns a hash of params for building the previous page link" do
          expect(search.previous_params).to eq({ q: "search", state: :exported, page: 2 })
        end
      end

      context "with a filter param" do
        let(:params) { { q: "search", page: "3", city: "London" } }
        let(:scope) { ->(param) { city(param) } }
        let(:filters) { { city: scope } }

        before do
          allow(klass).to receive(:city).with("London").and_return(klass)
        end

        it "returns a hash of params for building the previous page link" do
          expect(search.previous_params).to eq({ q: "search", page: 2, city: "London" })
          expect(klass).to have_received(:city).with("London")
        end
      end
    end

    describe "#next_params" do
      let(:arel_table) { double(:arel_table) }
      let(:building)   { double(:building) }
      let(:buildings)  { [building] }
      let(:results)    { double(:results, to_a: buildings) }

      before do
        allow(arel_table).to receive(:[]).with("*").and_return("*")
        allow(klass).to receive(:basic_search).with("search").and_return(klass)
        allow(klass).to receive(:except).with(:select).and_return(klass)
        allow(klass).to receive(:arel_table).and_return(arel_table)
        allow(klass).to receive(:select).with("*").and_return(klass)
        allow(klass).to receive(:except).with(:order).and_return(klass)
        allow(klass).to receive(:paginate).with(page: 3, per_page: 50).and_return(results)
        allow(results).to receive_messages(to_a: buildings, next_page: 4)
      end

      context "with default params" do
        it "returns a hash of params for building the previous page link" do
          expect(search.next_params).to eq({ q: "search", page: 4 })
        end
      end

      context "with a custom state param" do
        let(:params) { { q: "search", page: "3", state: "exported" } }

        it "returns a hash of params for building the previous page link" do
          expect(search.next_params).to eq({ q: "search", state: :exported, page: 4 })
        end
      end

      context "with a filter param" do
        let(:params) { { q: "search", page: "3", city: "London" } }
        let(:scope) { ->(param) { city(param) } }
        let(:filters) { { city: scope } }

        before do
          allow(klass).to receive(:city).with("London").and_return(klass)
        end

        it "returns a hash of params for building the previous page link" do
          expect(search.next_params).to eq({ q: "search", page: 4, city: "London" })
          expect(klass).to have_received(:city).with("London")
        end
      end

      context "with a custom state param and a filter param" do
        let(:params) { { q: "search", page: "3", state: "exported", city: "London" } }
        let(:scope) { ->(param) { city(param) } }
        let(:filters) { { city: scope } }

        before do
          allow(klass).to receive(:city).with("London").and_return(klass)
        end

        it "returns a hash of params for building the previous page link" do
          expect(search.next_params).to eq({ q: "search", state: :exported, page: 4, city: "London" })
          expect(klass).to have_received(:city).with("London")
        end
      end
    end

    describe "#query" do
      it "returns the query string" do
        expect(search.query).to eq("search")
      end
    end

    describe "#page_size" do
      context "when the count param is not set" do
        it "returns 50" do
          expect(search.page_size).to eq(50)
        end
      end

      context "when the count param is set to less than 50" do
        let(:params) { { q: "search", page: "1", count: "3" } }

        it "returns 3" do
          expect(search.page_size).to eq(3)
        end
      end

      context "when the count param is set to more than 50" do
        let(:params) { { q: "search", page: "1", count: "500" } }

        it "returns 50" do
          expect(search.page_size).to eq(50)
        end
      end

      context "when the count param is set to zero" do
        let(:params) { { q: "search", page: "1", count: "0" } }

        it "returns the default page size" do
          expect(search.page_size).to eq(50)
        end
      end

      context "when the count param is set to less than 0" do
        let(:params) { { q: "search", page: "1", count: "-10" } }

        it "returns the default page size" do
          expect(search.page_size).to eq(50)
        end
      end
    end

    describe "#scope" do
      context "when the search scope is valid" do
        let(:params) { { q: "search", page: "3", state: "exported" } }

        it "returns the current scope as a symbol" do
          expect(search.scope).to eq(:exported)
        end
      end

      context "when the search scope is invalid" do
        let(:params) { { q: "search", page: "3", state: "unknown" } }

        it "returns :all" do
          expect(search.scope).to eq(:all)
        end
      end

      context "when the search scope is not present" do
        let(:params) { { q: "search", page: "3" } }

        it "returns all" do
          expect(search.scope).to eq(:all)
        end
      end
    end

    describe "#scoped?" do
      context "when the search scope is the default" do
        let(:params) { { q: "search", page: "3", state: "all" } }

        it "returns false" do
          expect(search.scoped?).to be(false)
        end
      end

      context "when the search scope is valid" do
        let(:params) { { q: "search", page: "3", state: "exported" } }

        it "returns true" do
          expect(search.scoped?).to be(true)
        end
      end

      context "when the search scope is invalid" do
        let(:params) { { q: "search", page: "3", state: "demolished" } }

        it "returns false" do
          expect(search.scoped?).to be(false)
        end
      end

      context "when the search scope is not present" do
        let(:params) { { q: "search", page: "3" } }

        it "returns false" do
          expect(search.scoped?).to be(false)
        end
      end
    end

    describe "#search?" do
      context "when there is a query param" do
        it "returns true" do
          expect(search.search?).to be true
        end
      end

      context "when there is no query param" do
        let(:params) { { page: "1" } }

        it "returns false" do
          expect(search.search?).to be false
        end
      end
    end

    describe "#to_a" do
      let(:arel_table) { double(:arel_table) }
      let(:building)   { double(:building) }
      let(:buildings)  { [building] }
      let(:results)    { double(:results, to_a: buildings) }

      context "when there is a search term" do
        before do
          # This list of stubs is effectively testing the implementation of the
          # execute_search private method, however this is important because of
          # the need to exclude the ranking column added by the textacular gem
          # which can add a significant performance penalty.

          allow(arel_table).to receive(:[]).with("*").and_return("*")
          allow(klass).to receive(:basic_search).with("search").and_return(klass)
          allow(klass).to receive(:except).with(:select).and_return(klass)
          allow(klass).to receive(:arel_table).and_return(arel_table)
          allow(klass).to receive(:select).with("*").and_return(klass)
          allow(klass).to receive(:except).with(:order).and_return(klass)
          allow(klass).to receive(:paginate).with(page: 3, per_page: 50).and_return(results)
          allow(results).to receive(:to_a).and_return(buildings)
        end

        context "and the search is not scoped" do
          let(:params) { { q: "search", page: "3" } }

          it "returns the list of buildings" do
            expect(search.to_a).to eq(buildings)

            expect(arel_table).to have_received(:[]).with("*")
            expect(klass).to have_received(:basic_search).with("search")
            expect(klass).to have_received(:except).with(:select)
            expect(klass).to have_received(:arel_table)
            expect(klass).to have_received(:select).with("*")
            expect(klass).to have_received(:except).with(:order)
            expect(klass).to have_received(:paginate).with(page: 3, per_page: 50)
            expect(results).to have_received(:to_a)
          end
        end

        context "and the search is scoped" do
          let(:params) { { q: "search", page: "3", state: "all" } }

          before do
            allow(klass).to receive(:instance_exec).and_return(klass)
          end

          it "merges in the facet scope" do
            expect(search.to_a).to eq(buildings)

            expect(arel_table).to have_received(:[]).with("*")
            expect(klass).to have_received(:basic_search).with("search")
            expect(klass).to have_received(:except).with(:select)
            expect(klass).to have_received(:arel_table)
            expect(klass).to have_received(:select).with("*")
            expect(klass).to have_received(:except).with(:order)
            expect(klass).to have_received(:instance_exec)
            expect(klass).to have_received(:paginate).with(page: 3, per_page: 50)
            expect(results).to have_received(:to_a)
          end
        end
      end

      context "when there is not a search term" do
        before do
          allow(klass).to receive(:paginate).with(page: 3, per_page: 50).and_return(results)
        end

        context "and the search is not scoped" do
          let(:params) { { page: "3" } }

          it "returns the list of buildings" do
            expect(search.to_a).to eq(buildings)
            expect(klass).to have_received(:paginate).with(page: 3, per_page: 50)
          end
        end

        context "and the search is scoped" do
          let(:params) { { page: "3", state: "all" } }

          before do
            allow(klass).to receive(:instance_exec).and_return(klass)
          end

          it "merges in the facet scope" do
            expect(search.to_a).to eq(buildings)
            expect(klass).to have_received(:instance_exec)
            expect(klass).to have_received(:paginate).with(page: 3, per_page: 50)
          end
        end
      end
    end

    describe "#in_batches" do
      # Use an array that quacks like the expected ActiveRecord::Relation instance
      let(:batchified_array) do
        Class.new(Array) do
          alias_method :find_each, :each
        end
      end

      let(:search_results) { batchified_array.new([1, 2, 3]) }

      before do
        allow(search).to receive(:execute_search).and_return(search_results)
        allow(search_results).to receive(:find_each).and_call_original
      end

      it "uses ActiveRecord::Batches#find_each to load the results in batches" do
        expect do |block|
          search.in_batches(&block)
        end.to yield_successive_args(1, 2, 3)

        expect(search).to have_received(:execute_search)
        expect(search_results).to have_received(:find_each)
      end
    end
  end

  describe Browseable::Facets do
    let(:scope)   { -> { where(state: "exported") } }
    let(:query)   { double(:query) }
    let(:scopes)  { { exported: scope } }
    let(:klass)   { double(:klass, facet_definitions: scopes, filter_definitions: {}) }
    let(:facets)  { described_class.new(klass) }
    let(:filters) { Browseable::Filters.new(klass, {}) }

    describe "delegated methods" do
      subject { facets }

      it { is_expected.to delegate_method(:facet_definitions).to(:klass) }
      it { is_expected.to delegate_method(:key?).to(:facet_definitions) }
      it { is_expected.to delegate_method(:has_key?).to(:facet_definitions) }
      it { is_expected.to delegate_method(:keys).to(:facet_definitions) }
    end

    describe "#[]" do
      it "raises ArgumentError for unknown facets" do
        expect { facets[:unknown] }.to raise_error(ArgumentError)
      end

      it "returns the count for known facets" do
        allow(klass).to receive(:where).with(state: "exported").and_return(query)
        allow(query).to receive(:count).and_return(999)

        expect(facets[:exported]).to eq(999)
        expect(klass).to have_received(:where).with(state: "exported")
        expect(query).to have_received(:count)
      end
    end

    describe "#key?" do
      it "returns false when a key doesn't exist" do
        expect(facets.key?(:demolished)).to be(false)
      end

      it "returns true when a key exists" do
        expect(facets.key?(:exported)).to be(true)
      end

      it "doesn't execute the facet query" do
        allow(klass).to receive(:where)

        expect(facets.key?(:exported)).to be(true)
        expect(klass).not_to have_received(:where)
      end
    end

    describe "#keys" do
      it "returns the list of facet keys" do
        expect(facets.keys).to eq([:exported])
      end
    end

    describe "#slice" do
      before do
        scopes[:demolished] = -> { where(state: "demolished") }

        exported_query = double(:query)
        allow(klass).to receive(:where).with(state: "exported").and_return(exported_query)
        allow(exported_query).to receive(:count).and_return(999)

        demolished_query = double(:query)
        allow(klass).to receive(:where).with(state: "demolished").and_return(demolished_query)
        allow(demolished_query).to receive(:count).and_return(20)
      end

      it "returns a hash with only the specified keys and their counts" do
        expect(facets.slice(:exported)).to eq({ exported: 999 })
      end

      it "returns a hash with keys ordered by the supplied keys" do
        expect(facets.slice(:demolished, :exported).keys).to eq(%i[demolished exported])
      end

      it "does not raise if asked for unknown keys" do
        expect do
          facets.slice(:unknown)
        end.not_to raise_error
      end

      it "does not include unknown keys in the returned hash" do
        expect(facets.slice(:unknown)).to eq({})
      end
    end
  end

  describe Browseable::Filters do
    let(:klass) { double(:klass, filter_definitions: filter_definitions) }
    let(:filters) { described_class.new(klass, params) }

    describe "implicit conversion" do
      let(:filter_definitions) { {} }
      let(:params) { {} }

      it "can be merged with another hash" do
        expect { {}.merge(filters) }.not_to raise_error
      end
    end

    describe "#to_hash" do
      let(:filter) { -> { double(:filter) } }
      let(:filter_definitions) { { city: filter } }

      context "when the key is not present in the params hash" do
        let(:params) { {} }

        it "returns a hash without the filter key" do
          expect(filters.to_hash).to eq({})
        end
      end

      context "when the key is present in the params hash" do
        let(:params) { { city: "London" } }

        it "returns a hash with the filter key" do
          expect(filters.to_hash).to eq({ city: "London" })
        end
      end
    end
  end
end
