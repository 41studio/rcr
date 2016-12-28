Apipie.configure do |config|
  config.app_name                = "Obcheck"
  config.api_base_url            = "/api/v1"
  config.default_version         = "1.0"
  config.doc_base_url            = "/apipie"
  # where is your API defined?
  config.api_controllers_matcher = File.join(Rails.root, "app", "controllers", "api", "v1", "**","*.rb")
end

require 'apipie_custom_validator'