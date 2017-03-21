require 'rails_helper'

RSpec.describe Mail::Receiver do
  context 'sending a simple message' do
    let(:repository) { instance_double Repository }
    let(:receiver) {
      described_class.build \
        handler:    handler,
        repository: repository
    }

    context 'when handled' do
      let(:handler) { ->(m) { m } }

      it 'records a message' do
        expect(repository).to receive(:save_mail)

        receiver.call(from: 'from', to: 'to')
      end
    end

    context 'when erroring' do
      let(:handler) { ->(*_) { raise 'Forced error' } }

      it 'records a message' do
        expect(repository).to receive(:save_mail)

        expect do
          receiver.call(from: 'from', to: 'to')
        end.to raise_error RuntimeError, 'Forced error'
      end
    end
  end
end
