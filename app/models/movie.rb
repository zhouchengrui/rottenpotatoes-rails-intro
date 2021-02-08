class Movie < ActiveRecord::Base
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
#   if ratings_list is nil, retrieve ALL movies
    if ratings_list==nil and ratings_list=={}
      return Movie.all
    else 
      return Movie.where(rating: ratings_list.keys)
    end
  end
  

  
end
