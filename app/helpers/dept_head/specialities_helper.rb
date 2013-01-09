# -*- encoding : utf-8 -*-
module DeptHead::SpecialitiesHelper

  def list_row_class(record)
    record.department_id != current_dept_head.department_id ? 'alien-speciality' : ''
  end

end
