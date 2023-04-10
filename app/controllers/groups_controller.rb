class GroupsController < ApplicationController
  skip_before_action :verify_authenticity_token
  # group 생성
  def create
    group = Group.new(group_name: params[:group_name], usable: 1)
    group.save

    # group 안에 속해 있는 user 들의 정보 - UserGroup 모델에 저장
    @users_id = params[:users_id]
    @latest_group = Group.order("id DESC").limit(1)

    @users_id.each do |user_id|
      user_group_create(user_id, @latest_group[0]["id"])
    end

    # 생성한 그룹 info 
    group_info = Group.order("created_at desc").limit(1)

    render json: {
      status: "SUCCESS",
      message: "group created",
      group_info: group_info,
    }
  end

  # 특정 그룹의 그룹원 확인
  def check_member
    @group_member = UserGroup
                    .joins("INNER JOIN users ON users.id = user_groups.user_id")
                    .select("users.email, users.id")
                    .where("group_id = ? AND user_groups.usable = ?", params[:group_id], 1)
    
    @group_info = Group.find(params[:group_id])

    if @group_info.usable == 0
      @group_name = "group is removed."
    else
      @group_name = @group_info.group_name
    end

    render json: {
      status: "SUCCESS",
      message: "group info",
      group_name: @group_name,
      group_member: @group_member
    }, status: 200
  end

  # 생성된 그룹에 사람 추가
  def add_member
    @users_id = params[:users_id]
    @group_id = params[:group_id]

    
    @users_id.each do | user_id |
      @person = UserGroup.find_by(user_id: user_id, group_id: @group_id)

      if @person
        # 이미 db 에 생성된 정보가 있으면 논리 추가만 해주면 됨
        @person.update_attribute(:usable, 1) 
      else
        user_group_create(user_id, @group_id)
      end
    end
  end

  # 그룹에 있는 사람 삭제 
  def destory_member
    @users_id = params[:users_id]
    @group_id = params[:group_id]


    @users_id.each do | user_id |
      @user_group = UserGroup.where("user_id = ? and group_id = ?", user_id, @group_id)
                  .first
                  .update_attribute(:usable, 0)
    end
  end

  # group 삭제
  def destroy_group
    @group_id = params[:group_id]
    @group = Group.find(@group_id) # 그룹 찾기

    # 플리 block
    @group_playlist = Playlist.find_by(ownable_id: @group_id)
    if @group_playlist
      @group_playlist.update_attribute(:usable, 0)
    end

    # group block
    @group.update_attribute(:usable, 0)

    # user group block
    @user_group = UserGroup.where("group_id = ?", @group_id)
    @user_group.each do | user |
      user.update_attribute(:usable, 0)
    end

  end

  # 그룹 복구 
  def recover_group
    @group_id = params[:group_id]
    @group = Group.find(@group_id)

    # 플리 복구
    @group_playlist = Playlist.find_by(ownable: @group)
    if @group_playlist
      @group_playlist.update_attribute(:usable, 1)
    end

    # 그룹 복구
    @group.update_attribute(:usable, 1)

    # 유저 그룹 복구
    @user_group = UserGroup.where("group_id = ?", @group_id)
    @user_group.each do | user |
      user.update_attribute(:usable, 1)
    end

  end

  # user_group 추가 메소드
  def user_group_create(user_id, group_id)
    @ug = UserGroup.new(
          user_id: user_id,
          group_id: group_id,
          usable: 1
    )
    @ug.save
  end
end
