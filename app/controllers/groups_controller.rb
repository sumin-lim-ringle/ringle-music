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
    @group = Group.where("id = ?", @group_id)
    @group.first.update_attribute(:usable, 0)

    @user_group = UserGroup.where("group_id = ?", @group_id)
    @user_group.each do | user |
      user.update_attribute(:usable, 0)
    end

  end

  # 그룹 복구 - to do: 플레이리스트가 있다면 플리까지 복구
  def recover_group
    @group_id = params[:group_id]
    @group = Group.where("id = ?", @group_id)
    @group.first.update_attribute(:usable, 1)

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
