class MusicsController < ApplicationController
  def index
    @search = "%#{params[:keyword]}%"
    @sortby = params[:sortby] || ""

    sort =
      if @sortby == "popular"
        "likes_count DESC"
      elsif @sortby == "latest"
        "created_at DESC"
      else
        ""
      end

    @musics =
      Music.where(
        "music_name like ? or artist_name like ? or album_name like ? ",
        @search,
        @search,
        @search
      ).order(sort)

    render json: {
             status: "SUCCESS",
             message: "Musics list",
             data: @musics
           },
           status: 200
  end
end
