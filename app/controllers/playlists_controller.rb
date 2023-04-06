class PlaylistsController < ApplicationController
    skip_before_action :verify_authenticity_token

    # 그룹 또는 유저의 플레이리스트 자체를 생성하는 API
    def create
        if params[:ownable_type] == "person"
            @own = User.find_by(id: params[:id])
        else
            @own = Group.find_by(id: params[:id])
        end

        @playlist = Playlist.new(ownable: @own)
        if @playlist.save
            @p_id = Playlist.order("created_at desc").first.id
            render json: {
                 status: "success",
                 message: "#{params[:ownable_type]} playlist is created. playlist id is #{@p_id}"
               },
               status: 201
        else
            render json: {
                 status: "FAILED",
                 message: "playlist creation failed."
               },
               status: 400
        end
    end

    # 특정 플레이리스트 보기
    def view
        @data = MusicPlaylist
        .joins("
            INNER JOIN playlists ON  music_playlists.playlist_id = playlists.id
            INNER JOIN musics ON music_playlists.music_id = musics.id
            INNER JOIN users ON music_playlists.user_id = users.id 
        ")
        .select("playlists.ownable_type, musics.music_name, users.email")
        .where("playlist_id = ?", params[:playlist_id])


        render json: {
               status: "SUCCESS",
               message: "#{params[:playlist_id]}'s playlist",
               data: @data
             },
             status: 200

    end

    # 특정 플레이리스트에 음악 추가
    def add
        # N 개의 음악을 플레이리스트에 추가
        params[:musics_id].each do |music_id|
            @list = MusicPlaylist.new(
                music_id: music_id,
                playlist_id: params[:playlist_id],
                user_id: params[:user_id] # 추가한 사람
            )
            @list.save
        end

        # 플레이리스트에 100 개 이상 일 때 가장 먼저 저장된 N 개를 삭제
        @playlist_cnt = MusicPlaylist.where("playlist_id = ?", params[:playlist_id]).count
        @cnt_to_delete = @playlist_cnt - 100

        if @cnt_to_delete > 0
            @delete_element = MusicPlaylist.where("playlist_id = ?", params[:playlist_id]).order("created_at").limit(cnt_to_delete)

            @delete_element.each do | element |
                element.destroy
            end
        end
    end
    
    # 특정 플레이리스트에 음악 삭제
    def destroy
        params[:musics_id].each do |music_id|
            @music = MusicPlaylist.find_by(playlist_id: params[:playlist_id])
      
            if @music
              @music.destroy
            end
        end
    end
end
