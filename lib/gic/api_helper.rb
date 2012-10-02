module GettyImageChooser
  class ApiHelper
    attr_accessor :system_id, :system_pwd, :user_name, :user_pwd, :status, :token, :secure_token

    def initialize(system_id, system_pwd, user_name, user_pwd)
      @session_endpoint = "https://connect.gettyimages.com/v1/session/CreateSession"
      @image_search_endpoint = "https://connect.gettyimages.com/v1/search/SearchForImages"
      @system_id = system_id
      @system_pwd = system_pwd
      @user_name = user_name
      @user_pwd = user_pwd
    end

    def create_session
      request = {
          :RequestHeader => {:Token => ""},
          :CreateSessionRequestBody =>
              {
                  :SystemId => @system_id,
                  :SystemPassword => @system_pwd,
                  :UserName => @user_name,
                  :UserPassword => @user_pwd
              }
      }

      response = post_json(request, @session_endpoint)
      puts response
      @status = response["ResponseHeader"]["Status"]
      @token = response["CreateSessionResult"]["Token"]
      @secure_token = response["CreateSessionResult"]["SecureToken"]
    end
    
    # token received from CreateSession/RenewSession API call
    def search_for_images(page, phrase)
      item_start_number = page_start(page, 12)
      puts "token = #{@token}"
      request = {
          :RequestHeader => { :Token => @token},
          :SearchForImages2RequestBody => {
              :Query => { :SearchPhrase => phrase},
              :ResultOptions => {
                  :ItemCount => 12,
                  :ItemStartNumber => item_start_number
              }
          }
      }
      response = post_json(request, @image_search_endpoint)

      #status = response["ResponseHeader"]["Status"]
      images = response["SearchForImagesResult"]["Images"]
    end
    
    def page_start(page, size)
      size * (page - 1) + 1
    end

    def post_json(request, endpoint)
      #You may wish to replace this code with your preferred library for posting and receiving JSON data.
      uri = URI.parse(endpoint)
      http = Net::HTTP.new(uri.host, 443)
      http.use_ssl = true

      response = http.post(uri.path, request.to_json, {'Content-Type' =>'application/json'}).body
      #puts response
      JSON.parse(response)
    end
  end
end