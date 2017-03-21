class HTTP
  Error = Class.new StandardError

  def call method, path, opts={}
    response = HTTParty.send method, path, opts
    if response.code.to_s.start_with? '2'
      JSON.parse response.body
    else
      raise Error.new "#{response.code}: #{response.body}"
    end
  end
end
