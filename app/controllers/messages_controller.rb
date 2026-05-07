class MessagesController < ApplicationController
  before_action :set_chat

  def create
    content = params[:content].to_s.strip
    return head :unprocessable_entity if content.blank?

    # Suppress the WebSocket broadcast for the user message — it will be
    # appended immediately via the Turbo Stream HTTP response below instead.
    Message.suppressing_turbo_broadcasts do
      @message = @chat.add_message(role: :user, content: content)
    end

    # Auto-title the chat from the first message
    if @chat.messages.where(role: :user).count == 1
      @chat.update!(title: content.truncate(60, omission: "…"))
    end

    ChatStreamJob.perform_later(@chat.id)

    render turbo_stream: turbo_stream.append(
      "messages",
      partial: "messages/message",
      locals: { message: @message }
    )
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:chat_id])
  end
end
