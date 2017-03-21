class UserRepository < ROM::Repository::Base
  relations :users

  def for_email email, name:
  end
end
