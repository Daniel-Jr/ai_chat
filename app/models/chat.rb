class Chat < ApplicationRecord
  acts_as_chat

  belongs_to :user

  validates :title, presence: true

  scope :recent, -> { order(updated_at: :desc) }

  after_update_commit :broadcast_sidebar_update, :broadcast_title_update

  private

  def broadcast_sidebar_update
    broadcast_replace_to "user_#{user_id}",
      target: "chat_list",
      partial: "chats/list",
      locals: { chats: user.chats.recent, active_chat_id: id }
  end

  def broadcast_title_update
    broadcast_replace_to "chat_#{id}",
      target: "chat_#{id}_title",
      html: %(<h1 id="chat_#{id}_title" class="text-sm font-semibold text-neutral-800 dark:text-neutral-200">#{ERB::Util.html_escape(title)}</h1>)
  end
end
