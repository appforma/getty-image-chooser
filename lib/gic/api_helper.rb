module GettyImageChooser
  class ApiHelper
    attr_accessor :system_id, :system_pwd, :user_name, :user_pwd, :status, :token, :secure_token

    def initialize(system_id, system_pwd, user_name, user_pwd)
      @session_endpoint = "https://connect.gettyimages.com/v1/session/CreateSession"
      @image_search_endpoint = "https://connect.gettyimages.com/v1/search/SearchForImages"
      @download_auth_endpoint = "http://connect.gettyimages.com/v1/download/GetLargestImageDownloadAuthorizations"
      @download_endpoint = "https://connect.gettyimages.com/v1/download/CreateDownloadRequest"
      @details_endpoint = "https://connect.gettyimages.com/v1/search/GetImageDetails"
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
      images = response["SearchForImagesResult"]
    end
    
    def get_largest_image_download_authorization(image_id)
      request = {
          :RequestHeader => {
              :Token => @token,
              :CoordinationId => "MyUniqueId"
          },
          :GetLargestImageDownloadAuthorizationsRequestBody =>
              { :Images =>
                  [{
                    :ImageId => image_id
                  }]
              }
      }
  
      response = post_json(request, @download_auth_endpoint)
    end
    
    def create_download_request(download_token)
      #Secure token is required for create download request
      request = {
          :RequestHeader => {
              :Token => @secure_token,
              :CoordinationId => "MyUniqueId"
          },
          :CreateDownloadRequestBody =>
              { :DownloadItems =>
                    [{
                         :DownloadToken => download_token
                     }]
              }
      }
      response = post_json(request, @download_endpoint)
    end
    
    def get_image_details(assetIds)
      request = {
          :RequestHeader => {
              :Token => @token,
              :CoordinationId => "MyUniqueId"
          },
          :GetImageDetailsRequestBody => {
              :CountryCode => "USA",
              :ImageIds => assetIds,
              :Language => "en-us"
          }
      }
  
      response = post_json(request, @details_endpoint)
  
      # status = response["ResponseHeader"]["Status"]
      images = response["GetImageDetailsResult"]["Images"]
      puts "images = #{images}"
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