
class Admin::DashboardController < Admin::BaseController
  def index
  @users = current_user.organization.users
  @spaces = Space.where(organization: current_user.organization)

  @user_count = @users.count
  @role_breakdown = User.roles.keys.index_with(0)
  @users.group(:role).count.each { |role, count| @role_breakdown[role] = count }

  @all_age_groups = AgeGroup.pluck(:name)
  @age_group_breakdown = @all_age_groups.index_with(0)
  @users.joins(:age_group).group("age_groups.name").count.each do |group, count|
    @age_group_breakdown[group] = count
  end

  @space_type_breakdown = @all_age_groups.index_with(0)
  @spaces.joins(:required_age_group).group("age_groups.name").count.each do |group, count|
    @space_type_breakdown[group] = count
  end

  @active_users_count = @users.where(is_active: true).count
  @inactive_users_count = @users.where(is_active: false).count

  @parental_consents = ParentalConsent.joins(:user).where(users: { organization_id: current_user.organization.id })
  @pending_consents = @parental_consents.where(status: 'pending').count
  @accepted_consents = @parental_consents.where(status: 'accepted').count
  @rejected_consents = @parental_consents.where(status: 'rejected').count
  end
end
