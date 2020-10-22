ActiveAdmin.register Community do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :community_place, :community_date, :community_limit, :community_money, :community_all_tag, :community_content, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:community_place, :community_date, :community_limit, :community_money, :community_all_tag, :community_content, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
