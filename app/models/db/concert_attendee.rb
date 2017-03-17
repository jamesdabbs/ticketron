class DB::ConcertAttendee < ApplicationRecord
  belongs_to :concert, class_name: 'DB::Concert'
  belongs_to :user

  def status= stat
    self[:status] = stat.key
  end
  def status
    self[:status] && Tickets::STATUSES.fetch(self[:status].to_sym)
  end
end
