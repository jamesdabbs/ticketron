module Voice
  class Response < Dry::Struct
    attribute :speech,       T::String
    attribute :display_text, T::String

    def self.text str
      new speech: str, display_text: str
    end

    def as_json *_
      {
        source: 'Ticketron',
        speech: speech,
        displayText: display_text,
        data: {
          google: {
            expect_user_response: false,
            is_ssml: false
          }
        }
      }
    end
  end
end
