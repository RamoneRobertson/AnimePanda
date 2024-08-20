ActiveAdmin.register Anime do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :synopsis, :start_date, :end_date, :rating, :rank, :popularity, :picture_url, :episode_count, :studio, :trailer, :mal_id, :tag_list, :genre_list
  filter :title
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :synopsis, :start_date, :end_date, :rating, :rank, :popularity, :picture_url, :episode_count, :studio, :trailer, :mal_id, :tag_list, :genre_list]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
