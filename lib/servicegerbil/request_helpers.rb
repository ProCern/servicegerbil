module ServiceGerbil
  module RequestHelpers
    
    def ssj
      'application/vnd.absperf.ssbe+json'
    end

    def request_ssj(path, env = {})
      env['HTTP_ACCEPT'] = ssj
      request_with_digest_auth(path, env)
    end

    def get_ssj(path, env = {})
      env[:method] = "GET"
      request_ssj(path, env)
    end

    def post_ssj(path, json, env = {})
      env['CONTENT_TYPE'] = ssj
      env[:method] = "POST"
      env[:input] = json
      request_ssj(path, env)
    end

    def put_ssj(path, json, env = {})
      env['CONTENT_TYPE'] = ssj
      env[:method] = "PUT"
      env[:input] = json
      request_ssj(path, env)
    end

    def delete_ssj(path, env = {})
      env[:method] = "DELETE"
      request_ssj(path, env)
    end

  end
end

