# -*- encoding : utf-8 -*-
module Editor::Classrooms::ClassroomsSheetsHelper
  def buildings_for_select
    Building.all.map { |d| [d.name, d.id]}
  end
end
