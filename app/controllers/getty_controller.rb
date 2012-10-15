class GettyController < ApplicationController
  before_filter :initialize_api_helper
  skip_before_filter :ensure_canvas_connected_to_facebook
  
  def search_images
    @api_helper.create_session
    response = @api_helper.search_for_images(1, params["search"])
    puts "response = #{response}"
    render :json => response.to_json
  end
  
  def download_image
    @api_helper.create_session
    
    response = @api_helper.get_image_details([params["image_id"]])
    # response = @api_helper.get_largest_image_download_authorization(params["image_id"])
    # puts "response = #{response}"
    # download_token = response["GetLargestImageDownloadAuthorizationsResult"]["Images"][0]["Authorizations"][0]["DownloadToken"]
    # puts "Download_token = #{download_token}"
    # res = @api_helper.create_download_request(download_token)

    
    render :json => res.to_json
  end
  
  private
    def initialize_api_helper
      @api_helper = GettyImageChooser::ApiHelper.new(
        GettyImageChooser.system_id,
        GettyImageChooser.system_pwd,
        GettyImageChooser.user_name,
        GettyImageChooser.user_pwd
      )
    end
end
