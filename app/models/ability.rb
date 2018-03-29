class Ability
  include CanCan::Ability

  def initialize user
    if user.present?
      user_id = user.id

      acc_id = user.profile.money_account.id
      role = user.role.name

      if user.role.name == "Lawyer"
        user = user.lawyer
      end

      room_ids = user.room_ids

      can :read, [Profile, Lawyer, Review, Role, UserRole]
      can :update, Profile, user_id: user_id
      can [:read, :update], User, id: user_id

      can :read, Payment do |payment|
        room_ids.include? payment.room_id
      end
      
      can :read, MoneyAccount, id: acc_id
      can :read, DepositHistory, money_account_id: acc_id
      
      if role == "User"
        can :create, DepositHistory

        can :create, Review
        can :update, Review, user_id: user_id
        can :read, Room, user_id: user_id
      elsif role == "Lawyer"
        can :read, [Specialization, LawyerSpecialize]

        can :update, Lawyer, user_id: user_id

        can [:create, :read, :update, :destroy], Task do |task|
          room_ids.include? task.room_id
        end

        can :read, Room, lawyer_id: user.id
        can :create, Room
        can :update, Room, lawyer_id: user.id

        can :create, LawyerSpecialize
        can :destroy, LawyerSpecialize, lawyer_id: user.id
      end
    else
      can :read, [Profile, Lawyer, User, Review]
    end
  end
end
