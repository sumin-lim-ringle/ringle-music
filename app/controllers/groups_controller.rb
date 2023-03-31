class GroupsController < ApplicationController
  skip_before_action :verify_authenticity_token # 추후 로그인 작업 시 변경 예정
  def create
    group = Group.new
    group.group_name = params[:group_name]
    group.save

    # group 안에 속해 있는 user 들의 정보 - UserGroup 모델에 저장
    @users_id = params[:users_id]
    @latest_group = Group.order("id DESC").limit(1)

    # puts @latest_group[0]["id"]

    @users_id.each do |user_id|
      ug = UserGroup.new
      ug.user_id = user_id
      ug.group_id = @latest_group[0]["id"]
      ug.save
    end
  end
end
