RubyLLM.configure do |config|
  config.ollama_api_base = ENV.fetch("OLLAMA_API_BASE", "http://localhost:11434/v1")
  config.default_model   = ENV.fetch("DEFAULT_MODEL", "llama3.2")

  config.logger          = Rails.logger
  config.request_timeout = 300
end
