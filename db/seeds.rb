# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.new
user.email = 'seed1@alfieyfc.info'
user.name = 'AlfieABC'
user.password = '123456'
user.password_confirmation = '123456'
user.save!

user = User.new
user.email = 'seed2@alfieyfc.info'
user.name = 'AlfieXYZ'
user.password = '123456'
user.password_confirmation = '123456'
user.save!

Event.create([
  {
    title: "Seed Event 1",
    room_id: "W6YW0A",
    max_players: 2,
    event_date: Date.strptime("03/14/2022", "%m/%d/%Y"),
    owner_id: 1
  },
  {
    title: "Seed Event 2",
    room_id: "89TSJQ",
    max_players: 4,
    event_date: Date.strptime("03/16/2022", "%m/%d/%Y"),
    owner_id: 1
  },{
    title: "Seed Event 3",
    room_id: "DCGRRA",
    max_players: 5,
    event_date: Date.strptime("03/01/2022", "%m/%d/%Y"),
    owner_id: 2
  }
])

Participation.create([
  {
    user_id: 1,
    event_id: 1
  },
  {
    user_id: 1,
    event_id: 2
  },
  {
    user_id: 2,
    event_id: 3
  },
  {
    user_id: 1,
    event_id: 3
  }
])

Dish.create([
  {
    name: "Salmon Pot",
    img_url: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.SVQuKv9AV3rBM5ZnfCmtigHaE8%26pid%3DApi&f=1",
    user_id: 1,
    event_id: 1
  },
  {
    name: "Beef Wellington",
    img_url: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.pM4x-l8aOWM2Y4AMSVJlOgHaHa%26pid%3DApi&f=1",
    user_id: 1,
    event_id: 2
  },
  {
    name: "水煮牛蓋飯",
    img_url: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fs.hdnux.com%2Fphotos%2F17%2F42%2F76%2F4075424%2F3%2F975x0.jpg&f=1&nofb=1",
    user_id: 2,
    event_id: 3
  },
  {
    name: "Greek Braised Lamb",
    img_url: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.i2_qQVoy0wOPNOCBuJvd1gHaFf%26pid%3DApi&f=1",
    user_id: 1,
    event_id: 3
  },
  {
    name: "烤羊排",
    img_url: "https://cdn.apartmenttherapy.info/image/upload/f_auto,q_auto:eco,c_fit,w_764,h_1070/k%2Farchive%2F79977e42a856110f2b70c4ac5be9f0a7a5f5f02a",
    user_id: 2,
    event_id: 3
  },
])
