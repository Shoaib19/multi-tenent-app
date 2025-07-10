# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



# Clear existing
Organization.destroy_all
AgeGroup.destroy_all
User.destroy_all

# Create Age Groups
kids_group = AgeGroup.create!(name: "Child", min_age: 0, max_age: 12)
teen_group = AgeGroup.create!(name: "Teen", min_age: 13, max_age: 17)
adult_group = AgeGroup.create!(name: "Adult", min_age: 18, max_age: 99)

puts "Age groups created."

# Create Organizations
org1 = Organization.create!(name: "Alpha Org", description: "Org with Spaces", org_code: 0, settings_json: {
    features: { show_spaces_ui: true },
    labels: { spaces: 'Spaces' },
    participation_rules: {}
  })
org2 = Organization.create!(name: "Beta Org", description: "Org with Groups", org_code: 1, settings_json: {
    features: { show_groups_ui: true },
    labels: { groups: 'Groups' },
    participation_rules: {}
  })

puts "Organizations created."

# Create Admin Users
User.create!(
  email: "admin1@alpha.org",
  password: "password",
  password_confirmation: "password",
  role: 2,
  age_group: adult_group,
  organization: org1,
  date_of_birth: 30.years.ago
)

User.create!(
  email: "admin2@beta.org",
  password: "password",
  password_confirmation: "password",
  role: 2,
  age_group: adult_group,
  organization: org2,
  date_of_birth: 35.years.ago
)

puts "Admin users created."
