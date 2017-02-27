# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.new spotify_id: 'jamesdabbs'
user.save! validate: false

sk = Songkick::Scraper.new user: user, logger: Logger.new(STDOUT)
sk.import '28733214'
sk.import '28528294'
sk.import '29159124'
sk.import '29040569'
sk.import '29220299'
sk.import '28966259'
sk.import '29377334'
