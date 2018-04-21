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

      can :read, [User, Profile, Lawyer, Review, Role, UserRole]
      can :update, Profile, user_id: user_id
      can :update, User, id: user_id
      
      can :read, MoneyAccount, id: acc_id
      can :read, DepositHistory, money_account_id: acc_id

      can [:create, :read], RoomFile do |file|
        room_ids.include? file.room_id
      end
      
      if role == "User"
        can :create, DepositHistory

        can [:create, :update], Review do |review|
          review.user_id == user_id
        end

        can :read, Room do |room|
          room.user_id == user.id
        end

      elsif role == "Lawyer"
        can :read, Specialization

        can :update, Lawyer, user_id: user_id

        can [:create, :read, :update, :destroy], Task do |task|
          room_ids.include? task.room_id
        end

        can [:read, :update, :create], Room do |room|
          room.lawyer_id == user.id
        end

        can [:create, :destroy, :read], LawyerSpecialize do |lawyer_specialize|
          lawyer_specialize.lawyer_id == user.id
        end
      end
    else
      can :read, [Profile, Lawyer, User, Review]
    end
  end
end
