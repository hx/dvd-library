require 'yaml'

module ApiKeys
  api_keys_yaml = File.join Rails.root, 'api_keys.yml'
  abort 'Please create /api_keys.yml with keys "tmdb" and "tvdb"' unless File.exists? api_keys_yaml

  api_keys = YAML::load File.open api_keys_yaml

  Tmdb.api_key = api_keys['tmdb']
  Tmdb.default_language = 'en'

end