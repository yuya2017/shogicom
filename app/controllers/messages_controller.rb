class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = current_user.messages.new(message_params)
    if @message.save
      rendered_template = render @message
      ActionCable.server.broadcast "room_channel_#{@message.room_id}", message: rendered_template
    else
      error_place = Message.message_error(@message)
      redirect_to "/rooms/#{@message.room_id}/#{error_place}", notice: "メッセージが空白もしくは100文字を超えました。"
    end
  end

  private
  def message_params
    params.require(:message).permit(:message_content, :room_id).merge(room_id: session[:room_id])
  end
end
