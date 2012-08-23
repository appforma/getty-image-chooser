class Getty < Rails::Engine
  # Add a load path for this specific Engine
  config.autoload_paths << File.expand_path("../lib/some/path", __FILE__)
end