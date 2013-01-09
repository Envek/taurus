# -*- encoding : utf-8 -*-
class Speciality < ActiveRecord::Base
  belongs_to :department
  has_many :groups, :dependent => :destroy
  has_many :teaching_plans, :dependent => :destroy

  validates :code, :presence => true, :uniqueness => true,
                   :format => { :with => /\A(\d{6})(\.(62|65|68))?\z/ }
  validates :name, :presence => true
  validates :department_id, :presence => true

  def to_label
    "#{name} (#{code})"
  end

protected

  def authorized_for_update?
    return true unless current_user
    self.department_id == current_user.department_id
  end

  def authorized_for_delete?
    return true unless current_user
    self.department_id == current_user.department_id
  end

end
