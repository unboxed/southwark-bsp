# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

building_manager = BuildingManager.find_or_create_by(email: "example@example.com")
building = Building.find_or_create_by(address: "134 Test Row, London", UPRN: 20012524507, manager: building_manager)
survey = Survey.find_or_create_by(building_id: building.id)
