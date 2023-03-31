class UserPlaylistsController < ApplicationController
  skip_before_action :verify_authenticity_token # 추후 로그인 작업 시 변경 예정
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
    user_playlist = UserPlaylist.new
    user_playlist.music_id = params[:music_id]
    user_playlist.user_id = params[:user_id]
    user_playlist.save
  end

  def createAll
    @user_id = params[:user_id]
    @musics_id = params[:musics_id]

    @musics_id.each do |music_id|
      user_playlist = UserPlaylist.new
      user_playlist.music_id = music_id
      user_playlist.user_id = @user_id
      user_playlist.save
    end
  end

  def destroy
    @music =
      UserPlaylist.find_by(
        user_id: params[:user_id],
        music_id: params[:music_id]
      )

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

  def destroyAll
    @user_id = params[:user_id]
    @musics_id = params[:musics_id] # string, ex: 1,2,3,4

    @music_id_arr = @musics_id.split(",")

    @music_id_arr.each do |music_id|
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
end
