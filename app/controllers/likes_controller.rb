class LikesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def add_count
    @user_id = params[:user_id]
    @music_id = params[:music_id]
    @like_element = Like.find_by(user_id: @user_id, music_id: @music_id)

    @music = Music.find_by(@music_id.to_s)
    @origin_likes_count = Music.find_by(@music_id.to_s)["likes_count"]

    if @like_element # db 에 정보가 있을 경우
      if @like_element.likable == 1 #이미 좋아요 누른 경우
        ## 논리 삭제
        @like_element.update_attribute(:likable, 0)
        @music.update(likes_count: @origin_likes_count - 1)
      else # db 에 정보는 있는데 좋아요는 안누른 경우
        @like_element.update_attribute(:likable, 1)
        @music.update(likes_count: @origin_likes_count + 1)
      end
    else # 아직 좋아요를 누르지 않은 경우 (처음 좋아요를 누르는 경우)
      @likes = Like.new(
          user_id: @user_id,
          music_id: @music_id,
          likable: 1
      )
      @likes.save

      @music.update(likes_count: @origin_likes_count + 1)
    end
  end
end
