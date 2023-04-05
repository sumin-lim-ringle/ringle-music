class GroupPlaylistsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  protect_from_forgery prepend: true

  def index
    @group_id = params[:group_id]

    # using join to show data
    @data =
      GroupPlaylist
        .joins(
          "INNER JOIN users ON users.id = group_playlists.user_id 
           INNER JOIN musics ON group_playlists.music_id = musics.id 
           INNER JOIN groups ON groups.id = group_playlists.group_id"
        )
        .select(
          "users.email, musics.music_name, groups.group_name, group_playlists.id"
        )
        .where("group_id = ? ", @group_id)
        
      render json: {
               status: "SUCCESS",
               message: "#{params[:group_id]}'s group playlist",
               data: @data
             },
             status: 200
  end

  def create
    @user_id = params[:user_id]
    @group_id = params[:group_id]
    @musics_id = params[:musics_id]

    @musics_id.each do |music_id|
      @playlist_cnt = GroupPlaylist.where("group_id = ?", @group_id).count

      if @playlist_cnt >= 100
        # 가장 오래된 항목 삭제
        GroupPlaylist
          .where("group_id = ?", @group_id)
          .order("created_at DESC")
          .limit(1)
          .first
          .delete
        group_playlist_create(@user_id, @group_id, music_id)
      else
        group_playlist_create(@user_id, @group_id, music_id)
      end
    end
  end

  # post 로 만들어 놓은 상태
  def destroy
    @group_id = params[:group_id]
    @musics_id = params[:musics_id]

    @musics_id.each do |music_id|
      @music = GroupPlaylist.find_by(group_id: @group_id, music_id: music_id)

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

  def group_playlist_create(user_id, group_id, music_id)
    @group_playlist = GroupPlaylist.new(
          user_id: user_id,
          group_id: group_id,
          music_id: music_id
        )
    @group_playlist.save
  end
end
