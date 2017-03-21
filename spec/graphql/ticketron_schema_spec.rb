require 'rails_helper'

RSpec.describe TicketronSchema do
  before :all do
    truncate!

    @container = Ticketron.container.with do |c|
      c.google_calendar_sync { instance_double Google::CalendarSync }
    end

    @repository = @container.repository

    @user = @repository.user_for_email 'test@example.com', name: 'Test'

    @concerts = 5.times.map do
      c = @repository.ensure_concert build(:concert)
      @repository.add_tickets user: @user, concert: c, tickets: 1, method: Tickets::WillCall
      c
    end
  end
  after(:all) { truncate! }

  def run query, variables: {}
    context = {
      user:      @user,
      container: @container
    }
    result = TicketronSchema.execute query, variables: variables, context: context
    if result['errors']
      raise result['errors'].to_s
    end
    result
  end

  def viewer query, variables: {}
    run "query { viewer { #{query } } }", variables: variables
  end

  def mutation query, variables: {}
    run "mutation x { #{query } }", variables: variables
  end

  context 'queries' do
    it 'can fetch concerts' do
      result = viewer %|
        concerts {
          artists {
            name
          }
          venue {
            name
          }
          at
          attendees {
            user {
              name
            }
            number
            status
          }
        }
      |

      concerts = result.dig 'data', 'viewer', 'concerts'

      expect(concerts.count).to eq 5
      expect(concerts.sample['attendees'].count).to be >= 1
    end

    it 'can fetch mail' do
      mail = @repository.save_mail build(:mail, from: 'Test <test@example.com>')
      @repository.attach_concert mail: mail, concert: @concerts.last

      result = viewer %|
        mail {
          concert {
            venue {
              name
            }
          }
          from
        }
      |

      mail = result.dig 'data', 'viewer', 'mail'

      expect(mail.count).to eq 1
      expect(mail.first).to eq \
        'concert' => {
          'venue' => {
            'name' => '9:30 Club'
          }
        },
        'from' => 'Test <test@example.com>'
    end

    fit 'can fetch spotify' do
      _id = id
      @repository.update_spotify_playlist user: @user, url: _id, synced: Time.now

      result = viewer %|
        spotify {
          playlistUrl
          lastSynced
        }
      |

      spotify = result.dig 'data', 'viewer', 'spotify'

      binding.pry
      expect(spotify['playlistUrl']).to eq _id.to_s
      expect(spotify['lastSynced']).to be_within(1).of(Time.now.to_f)
    end

    it 'can fetch google calendar' do
      @repository.google_calendar_synced user: @user

      result = viewer %|
        googleCalendar {
          lastSynced
        }
      |

      calendar = result.dig 'data', 'viewer', 'googleCalendar'

      expect(calendar['lastSynced']).to be_within(1).of(Time.now.to_f)
    end
  end

  context 'mutations' do
    it 'can rsvp' do
      concert = @repository.ensure_concert build(:concert)

      expect(@repository).to receive(:add_tickets)

      result = mutation %|
        rsvp(input: {
          songkick_id: "#{concert.songkick_id}",
          tickets:     4,
          method:      will_call
        }) { ok }
      |

      expect(result.dig 'data', 'rsvp', 'ok').to eq true
    end

    it 'can sync calendar' do
      expect(@container.google_calendar_sync).to receive(:call).with user: @user

      result = mutation %|
        syncCalendar(input: {}) {
          updatedAt
        }
      |

      expect(result.dig('data', 'syncCalendar', 'updatedAt')).to be_within(1).of(Time.now.to_f)
    end

    it 'can sync spotify'
    it 'can create concert'
    it 'can request a friend'
    it 'can approve a friend'
  end
end
