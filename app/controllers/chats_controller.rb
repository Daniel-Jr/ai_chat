class ChatsController < ApplicationController
  before_action :set_chat, only: %i[show destroy]

  def index
    @chats = current_user.chats.recent
    @chat  = @chats.first
    redirect_to @chat if @chat
  end

  def show
    @chats = current_user.chats.recent
  end

  def create
    @chat = current_user.chats.build(
      title: params[:title].presence || "New Chat",
      model: RubyLLM.config.default_model
    )
    @chat.assume_model_exists = true
    @chat.provider = :ollama

    if @chat.save
      redirect_to @chat
    else
      redirect_to chats_path, alert: "Could not create chat."
    end
  end

  def destroy
    @chat.destroy
    redirect_to chats_path, notice: "Chat deleted."
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:id])
  end
end
