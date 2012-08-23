module GettyImageChooser
  class NotConfigured < Exception; end
  class << self
    attr_accessor :system_id, :system_pwd, :user_name, :user_pwd
  end
  
  require 'gic/getty'
  require 'gic/api_helper'
  require 'gic/view_helper'
        
  def self.system_id
    @system_id || raise_unconfigured_exception    
  end
  
  def self.system_pwd
    @system_pwd || raise_unconfigured_exception    
  end
  
  def self.user_name
    @user_name || raise_unconfigured_exception    
  end
  
  def self.user_pwd
    @user_pwd || raise_unconfigured_exception    
  end
    
  def self.raise_unconfigured_exception
    raise NotConfigured.new("No configuration provided for GettyImageChooser. Call GettyImageChooser.load_getty_yaml in an initializer")
  end
  
  def self.configuration=(hash)
    self.system_id = hash[:system_id]
    self.system_pwd = hash[:system_pwd]
    self.user_name = hash[:user_name]
    self.user_pwd = hash[:user_pwd]
  end
  
  def self.load_getty_yaml
    config = YAML.load(ERB.new(File.read(File.join(::Rails.root,"config","getty.yml"))).result)[::Rails.env]
    raise NotConfigured.new("Unable to load configuration for #{::Rails.env} from getty.yml. Is it set up?") if config.nil?
    self.configuration = config.with_indifferent_access
  end
end

