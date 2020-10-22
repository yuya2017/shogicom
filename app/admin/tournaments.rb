ActiveAdmin.register Tournament do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :tournament_chess, :tournament_app, :tournament_time, :tournament_content, :tournament_number_of_people, :tournament_limit, :tournament_date, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:tournament_chess, :tournament_app, :tournament_time, :tournament_content, :tournament_number_of_people, :tournament_limit, :tournament_date, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
