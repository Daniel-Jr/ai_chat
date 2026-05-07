class Message < ApplicationRecord
  acts_as_message

  broadcasts_to ->(message) { "chat_#{message.chat_id}" }

  def to_partial_path
    "messages/message"
  end

  # Called on every streaming chunk; replaces the content div so thinking
  # dots disappear and the accumulated text is always shown in full.
  def broadcast_streaming_content(full_content)
    broadcast_replace_to "chat_#{chat_id}",
      target: "#{ActionView::RecordIdentifier.dom_id(self)}_content",
      partial: "messages/content",
      locals: { message: self, content: full_content }
  end
end
