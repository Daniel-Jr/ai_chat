class OllamaService
  API_BASE = ENV.fetch("OLLAMA_API_BASE", "http://localhost:11434")
    .sub(%r{/v1/?$}, "")  # strip OpenAI-compat suffix if present

  # Returns an array of model name strings available in the local Ollama instance,
  # e.g. ["llama3.2", "mistral", "phi3"]. Returns [] if Ollama is unreachable.
  def self.available_models
    Rails.cache.fetch("ollama_models", expires_in: 60.seconds) do
      fetch_models
    end
  end

  def self.fetch_models
    uri = URI("#{API_BASE}/api/tags")
    response = Net::HTTP.start(uri.host, uri.port, open_timeout: 2, read_timeout: 4) do |http|
      http.get(uri.request_uri)
    end

    return [] unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body)
    data["models"]
      .map { |m| m["name"].sub(/:latest$/, "") }
      .sort
  rescue => e
    Rails.logger.warn("OllamaService: could not fetch models — #{e.message}")
    []
  end
end
