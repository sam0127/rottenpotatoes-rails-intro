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
    @all_ratings = Movie.all_ratings
    @sort = params[:sort]
    @ratings = params[:ratings]

    if @ratings.nil?
      @ratings = session[:ratings]
      if @ratings != params[:ratings]
        redir1 = true
      end
    end
    if @sort.nil?
      @sort = session[:sort]
      if @sort != params[:sort]
        redir2 = true
      end
    end

    if @ratings.nil?
      @movies = Movie.all.order(@sort)
    else
      @movies = Movie.where({rating: @ratings.keys}).order(@sort)
    end

    if redir1 || redir2
      flash.keep
      redirect_to movies_path ratings: @ratings, sort: @sort
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
