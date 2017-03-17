VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

RSpec.configure do |c|
  c.around :each, :vcr do |ex|
    name = ex.full_description.downcase.gsub(/\W+/, '-')

    VCR.use_cassette name, record: :new_episodes, re_record_interval: 2.weeks.to_i do
      ex.call
    end
  end
end
