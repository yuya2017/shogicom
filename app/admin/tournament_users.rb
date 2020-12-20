ActiveAdmin.register TournamentUser do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :tournament_id

  controller do
    def scoped_collection
      TournamentUser.includes(:user, :tournament)
    end
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :tournament_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
