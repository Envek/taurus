# -*- encoding : utf-8 -*-
module Department::SpecialitiesHelper

  def list_row_class(record)
    record.department_id != current_department.id ? 'alien-speciality' : ''
  end

end
