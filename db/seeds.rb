# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

company = Company.create(name: "41studio")
user = User.create(email: "mada@example.com", password: "12345678", password_confirmation: "12345678", company_id: company.id)
area = Area.create(name: "Toilet", company_id: company.id)
items = Item.create([{name: "Lantai", area_id: area.id},{name: "Dinding", area_id: area.id}, {name: "Full drain", area_id: area.id}])
ItemTime.create([{time: "9.00", item_id: Item.last.id}, {time: "14.00", item_id: Item.last.id}])
Indicator.create([{code: "A", description: "Great"}, {description: "Good", code: "B"}])
