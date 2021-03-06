# frozen_string_literal: true
module V0
  class InstitutionsController < ApiController
    # GET /v0/institutions/autocomplete?term=harv
    def autocomplete
      @data = []
      if params[:term]
        @search_term = params[:term]&.strip&.downcase
        @data = Institution.version(@version[:number]).autocomplete(@search_term)
      end
      @meta = {
        version: @version,
        term: @search_term
      }
      @links = { self: self_link }
      render json: { data: @data, meta: @meta, links: @links }, adapter: :json
    end

    # GET /v0/institutions?name=duluth&x=y
    def index
      @meta = {
        version: @version,
        count: search_results.count,
        facets: facets
      }
      render json: search_results.order(:institution).page(params[:page]), meta: @meta
    end

    # GET /v0/institutions/20005123
    def show
      resource = Institution.version(@version[:number]).find_by(facility_code: params[:id])

      raise Common::Exceptions::RecordNotFound, params[:id] unless resource

      @links = { self: self_link }
      render json: resource, serializer: InstitutionProfileSerializer,
             meta: { version: @version }, links: @links
    end

    private

    def normalized_query_params
      query = params.deep_dup
      query.tap do
        query[:name].try(:strip!)
        query[:name].try(:downcase!)
        %i(state country type).each do |k|
          query[k].try(:upcase!)
        end
        %i(category student_veteran_group yellow_ribbon_scholarship principles_of_excellence
           eight_keys_to_veteran_success).each do |k|
          query[k].try(:downcase!)
        end
      end
    end

    def search_results
      @query ||= normalized_query_params
      Institution.version(@version[:number])
                 .search(@query[:name])
                 .filter(:institution_type_name, @query[:type])
                 .filter(:category, @query[:category])
                 .filter(:country, @query[:country])
                 .filter(:state, @query[:state])
                 .filter(:student_veteran, @query[:student_veteran_group]) # boolean
                 .filter(:yr, @query[:yellow_ribbon_scholarship]) # boolean
                 .filter(:poe, @query[:principles_of_excellence]) # boolean
                 .filter(:eight_keys, @query[:eight_keys_to_veteran_success]) # boolean
    end

    # rubocop:disable Style/MutableConstant
    DEFAULT_BOOLEAN_FACET = { true: nil, false: nil }
    # rubocop:enable Style/MutableConstant

    # TODO: If filter counts are desired in the future, change boolean facets
    # to use search_results.filter_count(param) instead of default value
    def facets
      institution_types = search_results.filter_count(:institution_type_name)
      result = {
        category: {
          school: institution_types.except(Institution::EMPLOYER).inject(0) { |count, (_t, n)| count + n },
          employer: institution_types[Institution::EMPLOYER].to_i
        },
        type: institution_types,
        state: search_results.filter_count(:state),
        country: embed(search_results.filter_count(:country)),
        student_vet_group: DEFAULT_BOOLEAN_FACET,
        yellow_ribbon_scholarship: DEFAULT_BOOLEAN_FACET,
        principles_of_excellence: DEFAULT_BOOLEAN_FACET,
        eight_keys_to_veteran_success: DEFAULT_BOOLEAN_FACET
      }
      add_active_search_facets(result)
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def add_active_search_facets(raw_facets)
      if @query[:state].present?
        key = @query[:state].downcase
        raw_facets[:state][key] = 0 unless raw_facets[:state].key? key
      end
      if @query[:type].present?
        key = @query[:type].downcase
        raw_facets[:type][key] = 0 unless raw_facets[:type].key? key
      end
      if @query[:country].present?
        key = @query[:country].upcase
        raw_facets[:country] << { name: key, count: 0 } unless
          raw_facets[:country].any? { |c| c[:name] == key }
      end
      raw_facets
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Style/GuardClause

    # Embed search result counts as a list of hashes with "name"/"count"
    # keys so that open-ended strings such as country names do not
    # get interpreted/mutated as JSON keys.
    def embed(group_counts)
      group_counts.each_with_object([]) do |(k, v), array|
        array << { name: k, count: v }
      end
    end
  end
end
