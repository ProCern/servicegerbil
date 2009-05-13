require 'json'
require 'spec'

module ServiceGerbil

  module SsjParser
    def parse_response(response_or_body)
      doc = response_or_body.is_a?(Struct) ? response_or_body.body.to_s : response_or_body.to_s
      Mash.new(JSON.parse(doc))
    end
  end
  ::Spec::Matchers::Matcher.send(:include, SsjParser)

  module SsjHelpers

    share_as :SsjDocument do
      it 'should return a valid ssj document' do
        response.should be_successful
        response.should be_valid_json
        response.should have_ssj_content
      end
    end

    share_as :SsjCollectionDocument do
      it_should_behave_like SsjDocument

      it 'should return a representation of the collection' do
        response.should have_pair(:href,       String)
        response.should have_pair(:item_count, resource.size)
        response.should have_pair(:items,      Array)
      end

    end

    share_as :SsjResourceDocument do
      it_should_behave_like SsjDocument

      it 'should return a representation of the resource' do
        response.should have_pair(:_type,  resource.class.to_s)
        response.should have_pair(:href,   String)
      end
    end

    def extract_record(doc)
      type = doc[:_type]
      href = doc[:href]
      id   = href.split('/').last

      Kernel.const_get(type).get(id)
    end

    def extract_resource(response)
      response.should be_successful # don't try parsing error documents
      doc = parse_response(response)
      extract_record(doc)
    end

    def extract_collection(response)
      response.should be_successful # don't try parsing error documents
      doc = parse_response(response)

      doc[:items].map do |item|
        extract_record(item)
      end
    end

    ::Spec::Matchers.define :be_valid_json do 
      match do |response|

        begin
          parse_response(response)
        rescue JSON::ParserError => e
          @e = e
          false
        end
      end

      failure_message_for_should do |response|
        "Expected response body to be valid JSON. Parse Error: #{@e.message}"
      end

    end

    ::Spec::Matchers.define :have_ssj_content do
      match do |response|
        response.headers['Content-Type'] == "#{SSJ}; charset=utf-8"
      end
        
      failure_message_for_should do |response|
        "Expected response to have Content-Type \"#{SSJ}; charset=utf-8\", but it was #{response.headers['Content-Type']}"
      end

    end
    
    ::Spec::Matchers.define :have_pair do |key, value|
      match do |response|
        doc = parse_response(response)


        if doc.has_key?(key.to_s)
          doc_value = doc[key.to_s]

          case value
          when Regexp   then doc_value =~ value
          when UUID     then doc_value == value.to_s
          when DateTime then doc_value == value.iso8601
          when Class    then doc_value.is_a?(value)
          else
            doc_value == value
          end
        else
          false
        end
      end
      
      failure_message_for_should do |response|
        doc = parse_response(response)

        unless doc.has_key?(key.to_s)
          %Q{Expected document to have key "#{key}", but it was missing from #{doc.inspect}}
        else
          %Q{Expected document value for "#{key}" to be "#{value}", but it was #{doc[key.to_s].inspect}}
        end
      end
    end

  end
end

