require 'rails_helper'

RSpec.describe Mail::Receiver do
  xcontext 'sending a simple message' do
    Given(:receiver) { described_class.build handler: handler }

    When(:result) { receiver.call({ from: 'from', to: 'to' })}
    When(:mail)   { receiver.repository.last_mail }

    context 'when handled' do
      Given(:handler) { ->(m) { m } }

      Then { mail.from == 'from' }
      And  { mail.to == 'to' }
    end

    context 'when erroring' do
      Given(:handler) { ->(*_) { raise 'Forced error' } }

      Then { result == Failure(RuntimeError, 'Forced error') }
      And  { mail.from == 'from' }
      And  { mail.to == 'to' }
    end
  end
end
