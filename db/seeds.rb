# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

building = Building.find_or_create_by(building_name: "Oslo Tower", street: "1 Union Street", city_town: "London", postcode: "NW1235", uprn: "20012524507")
building_2 = Building.find_or_create_by(building_name: "Lol", street: "1 Union Street", city_town: "London", postcode: "NW1235", uprn: "12345678910")
survey = Survey.find_or_create_by(building_id: building.id)
