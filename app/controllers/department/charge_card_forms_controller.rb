class Department::ChargeCardFormsController < Department::BaseController
  include DepartmentsConcern

  def show
    charge_cards_form
  end

end
