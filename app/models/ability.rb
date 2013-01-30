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
    elsif user.department_id.present? # DeptHead
        can :browse, Lecturer
        can :browse, Discipline
        can :create, TeachingPlace
        can :manage, ChargeCard, discipline: { department_id: user.department_id }
        can :manage, TeachingPlace, department_id: user.department_id
        can :manage, Discipline, department_id: user.department_id
        can :manage, Classroom, department_id: user.department_id
        can :manage, Jet
        # All the difficulties with teaching plans
        can :read, Speciality
        can :create, Speciality, department_id: user.department_id
        can :update, Speciality, department_id: user.department_id
        can :destroy, Speciality, department_id: user.department_id
        can [:read, :browse], Group
        can :create, Group, speciality: { department_id: user.department_id }
        can :update, Group, speciality: { department_id: user.department_id }
        can :destroy, Group, speciality: { department_id: user.department_id }
    else
        can :read, Pair
        can :read, Group
        can :read, Lecturer
        can :read, Classroom
    end
  end
end
