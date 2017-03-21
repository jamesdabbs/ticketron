class Email < Dry::Struct
  attribute :id,          T::String
  attribute :user,        Object
  attribute :concert,     Concert.optional
  attribute :from,        T::String
  attribute :to,          T::String
  attribute :subject,     T::String
  attribute :html,        T::String
  attribute :text,        T::String
  attribute :received_at, T::DateTime

  def self.standardize email
    email =~ /<([^>]+)>/ ? $1 : email
  end
end
