require 'rails_helper'

RSpec.describe Voice::Handlers::UpcomingConcerts do
  Given(:_) { instance_double Voice::Request }

  Given(:repository) do
    instance_double Repository,
      user_for_voice_request: user,
      next_concert_for:       concert,
      tickets_status:         tickets,
      other_upcoming:         [nil, nil]
  end

  Given(:handler) { described_class.new repository: repository }

  context 'with upcoming concert' do
    Given(:concert) do
      instance_double Concert,
        artists: [build(:artist, name: 'Floop')],
        venue:   build(:venue, name: 'Place'),
        at:      3.days.from_now
    end
    Given(:user)    { User.new }
    Given(:tickets) { Tickets::WillCall }

    When(:response) { handler.call _ }

    Then { response.speech =~ /Your next concert is Floop at Place on/ }
    And  { response.speech =~ /at will call/i }
    And  { response.speech =~ /2 other concerts/i }
  end

  context 'with no upcoming concerts' do
    Given(:concert) { nil }
    Given(:user) { User.new }
    Given(:tickets) { Tickets::WillCall }

    When(:response) { handler.call _ }

    Then { response.speech == 'You have no upcoming concerts' }
  end

  context 'with no user account' do
    Given(:user)    { nil }
    Given(:concert) { nil }
    Given(:tickets) { Tickets::WillCall }

    When(:response) { handler.call _ }

    Then { response == Failure(Voice::Dispatch::UserNotFound) }
  end
end
