module ServiceGerbil
  module AuthenticationHelpers

    def login_as(user, password = nil)
      # Reset any previous authorization
      @test_challenge = nil

      username = user.is_a?(User) ? user.login : user

      @username, @password = username, password || username
    end

    def whoami?
      @username
    end

    def request_with_digest_auth(path, env)
      add_credentials_to(env, path)
      env[:jar] = nil # disable merb request test helper cookies
      response = request(path, env)

      if response.status == 401 && !@already_tried_auth
        # Try again, with auth this time
        update_credentials(response)
        @already_tried_auth = true
        response = request_with_digest_auth(path, env)
      end

      @already_tried_auth = false
      response
    end

    def update_credentials(challenge_response)
      @test_challenge = HTTPAuth::Digest::Challenge.from_header(challenge_response.headers['WWW-Authenticate'])
    end

    def add_credentials_to(env, path)
      env.merge!({'HTTP_AUTHORIZATION' => credentials_for(env, path)}) if @test_challenge
    end

    def credentials_for(env, path)
      HTTPAuth::Digest::Credentials.from_challenge(
        @test_challenge,
        :username => @username,
        :password => @password,
        :method => env[:method].to_s.upcase || "GET",
        :uri => path).to_header
    end


  end
end
