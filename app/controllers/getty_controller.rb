class GettyController < ApplicationController
  before_filter :initialize_api_helper
  skip_before_filter :ensure_canvas_connected_to_facebook
  
  def search_images
    @api_helper.create_session
    response = @api_helper.search_for_images(1, params["search"])
    puts "response = #{response}"
    render :json => response.to_json
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
