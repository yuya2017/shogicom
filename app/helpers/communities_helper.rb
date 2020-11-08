module CommunitiesHelper

  def community_number_of_people_limit(community)
    participant = community.community_users.all
    community.community_number_of_people.nil? || community.community_number_of_people > participant.count
  end

end
