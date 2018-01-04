class Movie < ActiveRecord::Base
    def self.possible_movie_ratings
        ['G','PG','PG-13','R']
    end
end
