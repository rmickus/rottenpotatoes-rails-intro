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
    @movies = Movie.all
    @all_ratings = ['G', 'PG', 'PG-13', 'R']

    session_ratings = session[:ratings]
    ratings = params[:ratings]
    if !ratings.nil? then
      session[:ratings] = ratings
      ratings = ratings.keys
      @movies = @movies.select {|movie| ratings.include? movie.rating }
    elsif !session_ratings.nil? then
      params[:ratings] = session_ratings
      session_ratings = session_ratings.keys
      @movies = @movies.select {|movie| session_ratings.include? movie.rating }
    end

    session_sort = session[:sort]
    sort = params[:sort]
    if sort == "title" then
      @movies = @movies.sort_by {|movie| movie.title }
      session[:sort] = "title"
    elsif sort == "release_date" then
      @movies = @movies.sort_by {|movie| movie.release_date }
      session[:sort] = "release_date"
    elsif sort == "none" then
      session.clear
      @movies = Movie.all
    elsif session_sort == "title" then
      @movies = @movies.sort_by {|movie| movie.title }
      params[:sort] = "title"
    elsif session_sort == "release_date" then
      @movies = @movies.sort_by {|movie| movie.release_date }
      params[:sort] = "release_date"
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
