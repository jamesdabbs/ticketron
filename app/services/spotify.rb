module Spotify
  Error        = Class.new StandardError
  NotLinked    = Class.new Error
  AddingFailed = Class.new Error
  NameMismatch = Class.new Error
end
