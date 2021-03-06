ActiveAdmin.register Post do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :post_chess, :post_app, :post_time, :post_all_tag, :post_content, :user_id

  controller do
    def scoped_collection
      Post.includes(:user)
    end
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:post_chess, :post_app, :post_time, :post_all_tag, :post_content, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
