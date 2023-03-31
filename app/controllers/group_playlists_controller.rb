class GroupPlaylistsController < ApplicationController
  skip_before_action :verify_authenticity_token # 추후 로그인 작업 시 변경 예정
  def create
    group_playlist = GroupPlaylist.new
    group_playlist.user_id = params[:user_id] # 추가한 사람
    group_playlist.group_id = params[:group_id]
    group_playlist.music_id = params[:music_id]
    group_playlist.save
  end
end
