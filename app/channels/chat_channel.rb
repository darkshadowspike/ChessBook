class ChatChannel < ApplicationCable::Channel
  def subscribed
     stream_from "chat_#{params['chat_room_id']}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
