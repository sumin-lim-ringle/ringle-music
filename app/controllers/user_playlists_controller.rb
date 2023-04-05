class UserPlaylistsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  protect_from_forgery prepend: true

  def index
    @user_id = params[:user_id]

    @data = UserPlaylist.where("user_id = ?", @user_id)

    @music_id_arr = Array.new
    @data.each { |d| @music_id_arr.append(d["music_id"]) }

    @playlist = Music.find(@music_id_arr)

    render json: {
             status: "SUCCESS",
             message: "#{params[:user_id]}'s playlist",
             data: @playlist
           },
           status: 200
  end

  def create
    @user_id = params[:user_id]
    @musics_id = params[:musics_id]

    @musics_id.each do |music_id|
      @playlist_cnt = UserPlaylist.where("user_id = ?", params[:user_id]).count

      if @playlist_cnt >= 100
        # 가장 오래된 항목 삭제
        UserPlaylist
          .where("user_id = ?", params[:user_id])
          .order("created_at DESC")
          .limit(1)
          .first
          .delete

        user_playlist_create(@user_id, music_id)
      else
        user_playlist_create(@user_id, music_id)
      end
    end
  end

  # post 로 만들어 놓은 상태
  def destroy
    @user_id = params[:user_id]
    @musics_id = params[:musics_id]

    @musics_id.each do |music_id|
      @music = UserPlaylist.find_by(user_id: @user_id, music_id: music_id)

      if @music
        @music.destroy
      else
        render json: {
                 status: "FAILED",
                 message: "This song is not added in your playlist."
               },
               status: 400
      end
    end
  end

  def user_playlist_create(user_id, music_id)
    @user_playlist = UserPlaylist.new(
          user_id: user_id,
          music_id: music_id
    )
    @user_playlist.save
  end

end
