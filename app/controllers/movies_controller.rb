class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @ratings_to_show = ['G','PG','PG-13','R','NC-17']
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    @ratings = params[:ratings] || session[:ratings] || {}
    @ratings_to_show = @ratings
    @movies = Movie.with_ratings(@ratings)
    
    @sort = params[:sort] || session[:sort]
    case @sort
    when 'title'
     @title_header = 'hilite'
    when 'release_date'
     @release_date_header = 'hilite'
    end
    
    if @ratings == {}
      Hash[@ratings.map {|rating| [rating, rating]}]
    end
    
    if params[:sort] != session[:sort]
      session[:sort] = @sort
      redirect_to :sort => @sort, :ratings => @ratings and return
    end
    
    if params[:ratings] != session[:ratings] 
      session[:sort] = @sort
      session[:ratings] = @ratings
      redirect_to :sort => @sort, :ratings => @ratings and return
    end
    
    if @sort
      @movies = Movie.with_ratings(@ratings).order(@sort)
    else
      @movies = Movie.with_ratings(@ratings)
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
