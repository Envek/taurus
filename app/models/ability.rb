class Ability
  include CanCan::Ability

  def initialize(user, params)
    as_action_aliases
    user ||= User.new # Guests

    if user.admin?
        can :manage, :all
    elsif user.supervisor?
        can :manage, :all
        cannot :manage, User
    elsif user.editor?
        can :manage, Pair
        can :read, :all
        cannot :read, User
    elsif user.department_ids.any? # DeptHead
        can :update, Department, id: user.department_ids 
        can [:read, :browse, :select], Lecturer
        can [:read, :create], ChargeCard
        can [:update, :destroy], ChargeCard, discipline: { department_id: user.department_ids }
        can [:read], TeachingPlace
        can [:create, :update, :destroy], TeachingPlace, department_id: user.department_ids
        can [:read, :browse], Discipline
        can [:create, :update, :destroy], Discipline, department_id: user.department_ids
        can [:read], Classroom
        can [:update], Classroom, department_id: user.department_ids
        can :manage, Jet
        can [:read], Speciality
        can [:create, :update, :destroy], Speciality, department_id: user.department_ids
        can [:read, :browse], Group
        can [:create, :update, :destroy], Group, speciality: { department_id: user.department_ids }
    else
        can :read, Pair
        can :read, Group
        can :read, Lecturer
        can :read, Classroom
    end
  end
end
