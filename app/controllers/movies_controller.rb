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
    @all_ratings = Movie.ratings # to use it in index.html.haml
    session[:title_h] = params[:sort] == 'title' ? "hilite" : nil
    session[:release_date_h] = params[:sort] == 'release_date' ? "hilite" : nil
    session[:selected] = if params[:ratings]
                           params[:ratings].keys
                         else
                           session[:selected] ? session[:selected] : @all_ratings
                         end
    session[:sort] = params[:sort] ? params[:sort] : 'id'
    # remember settings incase not provided
    if params[:ratings].nil? || params[:sort].nil?
      flash.keep
      redirect_to movies_path(ratings: Hash[session[:selected].map {|s| [s, 1]}], sort: session[:sort])
    end
    @movies = Movie.where(rating: session[:selected]).order(session[:sort])
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
