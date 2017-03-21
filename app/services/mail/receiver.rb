module Mail
  class Receiver < Gestalt[:handler, :repository, :logger]
    def self.build handler: nil, repository: nil, logger: nil
      new \
        handler:    handler    || Mail::Handler.new,
        logger:     logger     || Rails.logger,
        repository: repository || Repository.new
    end

    def call params
      mail = repository.save_mail \
        received_at: Time.now,
        from:        params[:from],
        to:          params[:to],
        subject:     params[:subject],
        headers:     params[:headers],
        html:        params[:html],
        text:        params[:text]
      handler.call mail
    end
  end
end
