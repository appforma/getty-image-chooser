class GettyController < ApplicationController
  before_filter :initialize_api_helper
  def search_images
    @api_helper.create_session
    response = @api_helper.search_for_images(1, params["search"])
    render :json => response.to_json
  end
  
  private
    def initialize_api_helper
      @api_helper = GettyImageChooser::ApiGHelper.new(
        GettyImageChooser.system_id,
        GettyImageChooser.system_pwd,
        GettyImageChooser.user_name,
        GettyImageChooser.user_pwd
      )
    end
end
