class ChatStreamJob < ApplicationJob
  queue_as :default

  def perform(chat_id)
    chat = Chat.find(chat_id)
    chat.assume_model_exists = true
    chat.provider = :ollama
    full_content = ""
    assistant_message = nil

    chat.complete do |chunk|
      next unless chunk.content.present?

      # Lazily resolve the assistant message created by ruby_llm for this turn
      assistant_message ||= chat.messages.where(role: :assistant).last
      next unless assistant_message

      full_content += chunk.content
      assistant_message.broadcast_streaming_content(full_content)
    end
  rescue => e
    Rails.logger.error("ChatStreamJob failed for chat #{chat_id}: #{e.message}")
    raise
  end
end
