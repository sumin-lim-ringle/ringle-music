class UserDestroysController < ApplicationController
    skip_before_action :verify_authenticity_token
    def destroy
        begin
            # user table 에서 해당 유저 block
            @user = User.find(params[:user_id])

            # 개인 playlist 에 해당 아이디가 있다면 block 처리
            @user_playlist =  Playlist.find_by(ownable_id: params[:user_id])
            if @user_playlist
                @user_playlist.update_attribute(:usable, 0)
            end

            # 해당 유저 block
            @user.update_attribute(:usable, 0)

            #user_group table 에서도 해당 유저 block
            @user_group = UserGroup.where("user_id = ?", params[:user_id])
            @user_group.each do | user |
                user.update_attribute(:usable, 0)
            end
        rescue => e #exception handling
            render json: {
                status: "FAILED",
                message: "#{e}"
            }
        end
        
    end
end
