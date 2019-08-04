class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat_channel'
  end

  def unsubscribed; end

  def create(opts)
    chatroom = ChatRoom.find(1)
    message = chatroom.messages.create(text: opts.fetch('text'), user: User.find(1))
    ActiveRecord::Base.after_transaction do
      ChatMessageCreationEventBroadcastJob.perform_later(message)
    end
  end
end
