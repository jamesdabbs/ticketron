module ControllerHelpers
  def inject opts
    expect(controller).to receive(:container).and_return(double 'Container', opts)
  end

  def json
    @json ||= Hashie::Mash.new JSON.parse response.body
  end
end

RSpec.configure do |c|
  c.include ControllerHelpers, type: :controller
  c.include Devise::Test::ControllerHelpers, type: :controller
end
