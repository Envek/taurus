class Ability
  include CanCan::Ability

  def initialize(user, params)
    as_action_aliases if defined?(as_action_aliases)
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
    elsif user.department_ids.any? or user.faculty_ids.any? # Department head or faculty head
        can :update, Faculty, id: user.faculty_ids if user.faculty_ids.any?
        department_ids = Faculty.where(id: user.faculty_ids).map(&:department_ids).flatten | user.department_ids
        group_ids = Department.where(id: department_ids).includes(:groups).map(&:group_ids).flatten
        can :read, TrainingAssignment
        can :manage, TrainingAssignment, groups: {id: group_ids}
        can [:read, :update, :charge_cards_form], Department, id: department_ids
        can [:read, :browse, :select], Lecturer
        can [:read, :create], ChargeCard
        can [:update, :destroy], ChargeCard, disciplines: { department_id: department_ids }
        can [:read], TeachingPlace
        can [:create, :update, :destroy], TeachingPlace, department_id: department_ids
        can [:read, :browse], Discipline
        can [:create, :update, :destroy], Discipline, department_id: department_ids
        can [:read], Classroom
        can [:update], Classroom, department_id: department_ids
        can :manage, Jet
        can [:manage, :upload_teaching_plan], Speciality, department_id: department_ids
        can [:read, :browse], Group
        can [:create, :update, :destroy], Group, speciality: { department_id: department_ids }
    else
        can :read, Pair
        can :read, Group
        can :read, Lecturer
        can :read, Classroom
    end
  end
end
