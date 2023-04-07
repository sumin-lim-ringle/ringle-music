class MusicsController < ApplicationController
  def index
    @search = "%#{params[:keyword]}%"
    @sortby = params[:sortby] || ""

    sort =
      if @sortby == "popular"
        "likes_count"
      else
        "_score" # 이미 정확도 순으로 search 를 진행하기 때문에 elasticsearch 의 score 로 sorting
      end

    if @sortby == "latest"
      @musics = Music
                .where("music_name LIKE ? OR artist_name LIKE ? OR album_name LIKE ?", @search, @search, @search)
                .order("created_at desc")
    else
      @musics = Music.search_word_sort(params[:keyword], sort) 
    end
    
    render json: {
             status: "SUCCESS",
             message: "Musics list",
             data: @musics
           },
           status: 200
  end
end
