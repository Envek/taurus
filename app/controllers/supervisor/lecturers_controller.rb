class Supervisor::LecturersController < Supervisor::BaseController
  active_scaffold do |config|
    config.columns = [:name, :whish, :departments]
    config.columns[:departments].clear_link
    config.actions << :delete
    config.list.sorting = { :name => :asc }
    config.nested.add_link :teaching_places, :label => I18n.t("teaching_places", :scope => "activerecord.attributes.lecturer")
  end
end
