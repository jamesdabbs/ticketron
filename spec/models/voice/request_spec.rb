require 'rails_helper'

RSpec.describe Voice::Request do
  it 'can parse from params' do
    request = described_class.from_params \
      result: {
        action: 'floop'
      },
      originalRequest: {
        data: {
          user: {
            user_id: 1
          }
        }
      }

    expect(request.action).to eq 'floop'
    expect(request.user_id).to eq 1
  end
end
