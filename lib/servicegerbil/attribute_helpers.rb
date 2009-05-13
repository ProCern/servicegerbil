module ServiceGerbil

  module AttributeGroupHelpers

    def should_require_attributes(*attrs)
      attrs.each do |key|
        it "should require attribute #{key} be present" do
          subject(key => nil)
          response.should be_record_invalid_error
          response.should have_errors_on(key)
        end
      end
    end
    alias should_require_attribute should_require_attributes

    def should_ignore_attributes(*attrs)
      attrs.each do |key|
        it "should not set a value for #{key} if it is provided" do
          subject(key => "Ignore Me!")
          response.should be_successful
          if resource.respond_to?(key)
            resource.send(key).should_not == "Ignore me"
          end
        end
      end
    end
    alias should_ignore_attribute should_ignore_attributes

    def should_validate_type(expected_type)
      it "should be successful when _type is #{expected_type}" do
        subject(:_type => expected_type)
        response.should be_successful
      end

      it "should be client error if _type is not #{expected_type}" do
        subject(:_type => 'FooBar')
        response.should be_client_error
        response.should be_error_type('BadRequest')
        response.should have_error_message("Document must have type '#{expected_type}'")
      end
    end

    def should_have_pairs(pairs = {}, &block)
      if block_given?
        it 'should contain the specified attributes' do
          # need to evaluate the response before we enter the block
          # in case anything inside the block changes as a result of 
          # performing the request
          response
          instance_eval(&block).each do |k,v|
            response.should have_pair(k,v)
          end
        end
      else
        # The slow way
        pairs.each do |k,v|
          it "should have a \"#{k}\" attribute with value \"#{v}\"" do
            response.should have_pair(k,v)
          end
        end
      end
    end

    def should_assign_attributes(pairs = {})
      pairs.each do |key, val|
        it "should allow the value of \"#{key}\" to be set to \"#{val}\"" do
          subject(key => val)
          response.should be_successful
          response.should have_pair(key, val)
          resource.send(key).should == val
        end
      end

    end

  end

  module AttributeExampleHelpers

    ::Spec::Matchers.define(:have_errors_on) do |attribute|
      match do |response|
        doc = JSON.parse(response.body.to_s)
        doc['errors'].detect{ |e| e['field'] == attribute.to_s }
      end

      failure_message_for_should do |response|
        "Expected response to have errors on #{attribute}, but there were none."
      end
    end

    ::Spec::Matchers.define(:be_error_type) do |error_type|

      match do |response|
        doc = JSON.parse(response.body.to_s)
        doc['_type'].include?(error_type)
      end

      failure_message_for_should do |response|
      "Document should have error of type #{error_type}, but it was #{JSON.parse(response.body.to_s)['_type']}"
      end
    end

    ::Spec::Matchers.define(:have_error_message) do |expected_msg|

      match do |response|
        doc = parse_response(response)
        message = doc['exceptions'].first['message']
        message.include?(expected_msg)
      end

      failure_message_for_should do |response|
      "Document should have error message \"#{expected_msg}\", but it was #{parse_response(response)['exceptions'].first['message']}"
      end
    end

  end

end
