class MailController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate_user!, only: [:create]

  def create
    # FIXME: need to verify sender authenticity
    container.mail_receiver.call params
  ensure
    head :ok
  end

  def index
    @mail = repo.mail_from(current_user).sort_by { |m| -m.created_at.to_f }
  end

  def show
    @mail = Mail.find params[:id]
  end

  def retry
    ProcessMailJob.new.perform Mail.find params[:id]
    redirect_to :back
  end
end