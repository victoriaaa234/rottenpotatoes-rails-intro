class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.possible_movie_ratings
    @movies = Movie.all

    if !params[:ratings].nil? 
      session[:filtered_ratings] = params[:ratings]
    end 

    if !session[:filtered_ratings].nil?
        @movies = Movie.where(:rating => session[:filtered_ratings].keys)
    end

    if params[:order] == "title" 
      @highlight_title = "hilite"
      @movies = @movies.sort do |movie_1, movie_2| movie_1.title <=> movie_2.title end     
    elsif params[:order] == "release_date"
      @highlight_release_date = "hilite"
      @movies = @movies.sort do |movie_1, movie_2| movie_1.release_date <=> movie_2.release_date end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
