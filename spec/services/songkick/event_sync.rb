require 'rails_helper'

RSpec.describe Songkick::EventSync do
  let(:songkick)   { instance_double Songkick }
  let(:repository) { container.repository }

  let(:user) { build :user }
  let(:sync) { described_class.new songkick: songkick, repository: repository }

  it 'creates events from Songkick' do
    sync.call user: user
  end

  it 'requires a Songkick username'
end
