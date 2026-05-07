class ChatsController < ApplicationController
  before_action :set_chat, only: %i[show update destroy]

  def index
    @chats = current_user.chats.recent
    @chat  = @chats.first
    redirect_to @chat if @chat
  end

  def show
    @chats            = current_user.chats.recent
    @available_models = OllamaService.available_models
    # Always include the chat's current model even if Ollama is unreachable
    current_model = @chat.model&.model_id
    @available_models |= [current_model] if current_model.present?
  end

  def create
    @chat = current_user.chats.build(
      title: params[:title].presence || t("chats.default_title")
    )
    @chat.assume_model_exists = true
    @chat.provider = :ollama
    @chat.model    = RubyLLM.config.default_model

    if @chat.save
      redirect_to @chat
    else
      redirect_to chats_path, alert: t("chats.create_error")
    end
  end

  def update
    @chat.assume_model_exists = true
    @chat.provider = :ollama

    if @chat.update(model: params.dig(:chat, :model))
      redirect_to @chat
    else
      redirect_to @chat, alert: t("chats.update_error")
    end
  end

  def destroy
    @chat.destroy
    redirect_to chats_path, notice: t("chats.deleted")
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:id])
  end
end
