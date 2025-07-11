#puts "🌱 Seeding..."

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

puts "✅ Organizations created"

# Create Admin Users
admin1 = User.create!(
  email: "admin@alpha.org",
  password: "password",
  password_confirmation: "password",
  role: 2,
  is_active: true,
  age_group: adult_group,
  organization: org1,
  date_of_birth: 30.years.ago
)

admin2 = User.create!(
  email: "admin@beta.org",
  password: "password",
  password_confirmation: "password",
  role: 2,
  is_active: true,
  age_group: adult_group,
  organization: org2,
  date_of_birth: 35.years.ago
)

puts "Admin users created."

# Helper to create user with age group
def create_user(email, role, dob, org, age_group, active: true)
  user = User.find_or_initialize_by(email: email)
  user.password = "password"
  user.password_confirmation = "password"
  user.date_of_birth = dob
  user.role = role
  user.organization = org
  user.is_active = active
  user.save!
  user.age_group = age_group
  user
end

puts "✅ Admins created"

# Moderators
mod1 = create_user("mod1@alpha.com", :moderator, 28.years.ago.to_date, org1, adult_group)
mod2 = create_user("mod2@beta.com", :moderator, 32.years.ago.to_date, org2, adult_group)

puts "✅ Moderators created"

# Adults
2.times do |i|
  create_user("adult#{i+1}@alpha.com", :default_user, 27.years.ago.to_date, org1, adult_group)
  create_user("adult#{i+1}@beta.com", :default_user, 29.years.ago.to_date, org2, adult_group)
end

# Teens
2.times do |i|
  create_user("teen#{i+1}@alpha.com", :default_user, 16.years.ago.to_date, org1, teen_group)
  create_user("teen#{i+1}@beta.com", :default_user, 17.years.ago.to_date, org2, teen_group)
end

# Children
2.times do |i|
  create_user("child#{i+1}@alpha.com", :default_user, 10.years.ago.to_date, org1, kids_group)
  create_user("child#{i+1}@beta.com", :default_user, 12.years.ago.to_date, org2, kids_group)
end

puts "✅ Users by age groups created"

# Spaces for Alpha Org
[
  { name: "Alpha Adult Space", desc: "For adults only", age_group: adult_group, creator: admin1 },
  { name: "Alpha Teen Space", desc: "For teens", age_group: teen_group, creator: mod1 },
  { name: "Alpha Kids Space", desc: "For children", age_group: kids_group, creator: mod1 }
].each do |s|
  Space.find_or_create_by!(
    name: s[:name],
    organization: org1
  ) do |space|
    space.description = s[:desc]
    space.required_age_group = s[:age_group]
    space.creator = s[:creator]
  end
end

# Spaces for Beta Org
[
  { name: "Beta Adult Lounge", desc: "Adults discuss here", age_group: adult_group, creator: admin2 },
  { name: "Beta Teen Club", desc: "For our teens", age_group: teen_group, creator: mod2 },
  { name: "Beta Kids Corner", desc: "Play and learn", age_group: kids_group, creator: mod2 }
].each do |s|
  Space.find_or_create_by!(
    name: s[:name],
    organization: org2
  ) do |space|
    space.description = s[:desc]
    space.required_age_group = s[:age_group]
    space.creator = s[:creator]
  end
end

puts "✅ Spaces created"

puts "🌱 Seeding complete!"
