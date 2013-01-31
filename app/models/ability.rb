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
        can :browse, Lecturer
        can :browse, Discipline
        can :create, TeachingPlace
        can :manage, ChargeCard, discipline: { department_id: user.department_ids }
        can :manage, TeachingPlace, department_id: user.department_ids
        can :manage, Discipline, department_id: user.department_ids
        can :manage, Classroom, department_id: user.department_ids
        can :manage, Jet
        # All the difficulties with teaching plans
        can :read, Speciality
        can :create, Speciality, department_id: user.department_ids
        can :update, Speciality, department_id: user.department_ids
        can :destroy, Speciality, department_id: user.department_ids
        can [:read, :browse], Group
        can :create, Group, speciality: { department_id: user.department_ids }
        can :update, Group, speciality: { department_id: user.department_ids }
        can :destroy, Group, speciality: { department_id: user.department_ids }
    else
        can :read, Pair
        can :read, Group
        can :read, Lecturer
        can :read, Classroom
    end
  end
end
