class Spy
  def initialize
    @calls = []
  end

  def _calls
    @calls
  end

  def method_missing *args
    @calls.push args
  end
end

module SpyHelpers
  def spy
    @spy ||= Spy.new
  end

  def calls
    spy._calls
  end
end

RSpec.configure do |c|
  c.include SpyHelpers
end
