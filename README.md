# README

Ringle Music toy project.

## VERSION
- Ruby 2.7.2
- Rails 7.0.4


## INSTALL
- bundle install
- rails db:create
- rails db:migrate
- rails db:seed

## REQUIREMENT
- [x]  회원 가입 기능
- [x]  로그인 기능
- [x]  조회 API 관련 (GET)
    - [x]  query string: keyword, sortby
    - [x]  API 반환값: [곡명, 아티스트명, 앨범명, 좋아요 수]
    - [x]  좋아요 누르기 기능
    - [x]  sorting
        - [x]  인기순: 좋아요 기준 정렬
        - [x]  최신순: 등록일 기준 정렬
        - [x]  정확도 기준: 곡명 → 아티스트명 → 앨범명            
- [x]  개인 플레이리스트 API 관련
    - [x]  재생목록 조회 API
    - [x]  재생목록 추가 API (N개)
        - [x]  100 개 넘으면 가장 오래 전에 저장한 항목 삭제
    - [x]  재생목록 삭제 API (N개)
- [x]  그룹 플레이리스트 API 관련
    - [x]  그룹 만들기 기능
    - [x]  그룹 플레이리스트 조회
    - [x]  기존 그룹에 인원 추가
    - [x]  재생목록 추가 API (N개)
        - [x]  100 개 넘으면 가장 오래 전에 저장한 항목 삭제 - N+1 querying
    - [x]  재생목록 삭제 API (N개)
- [x]  그룹 관련
    - [x]  그룹 추가/삭제 기능 
    - [x]  그룹 내 유저 추가 /삭제 
    - [x]  그룹 복구 기능

## MODEL
- [ ]  Music - 음악 정보 담은 모델
    
    id, created_at, music_name(string), artist_name(string), album_name(string), likes_count(number)
    
- [ ]  User - 사용자 정보 담은 모델
    
    id, created_at, updated_at, user_name(string), password(string), usable(integer)
    
- [ ]  Group - 그룹 정보 담은 모델
    
    id, created_at, updated_at, group_name(string), usable(integer)
    
- [ ]  UserGroup - 유저와 그룹을 연결하는 모델
id, created_at, updated_at, user_id, group_id
- [ ]  Like - 좋아요 정보 담은 모델
    
    id, created_at, updated_at, music_id(number), user_id(number)  
    
- [ ]  Playlist - Polymorphic 모델
id, created_at, updated_at, ownable(ownable_type[User, Group], ownable_id)
- [ ]  MusicPlaylist - 플레이리스트 별로 추가한 사람과 음악명을 가지고 있는 모델
    
    id, created_at, updated_at, user_id, music_id, playlist_id

## CONTROLLER
- [ ]  Musics
- [ ]  Likes
- [ ]  Groups
- [ ]  Users
- [ ]  Playlists

## API
### 회원 가입 API

<aside>
💡 **[POST]** /users

body : {
    email: string,
    password: string,
}

</aside>

### 로그인 API

<aside>
💡 **[POST]** /login

body : {
    email: string,
    password: string,
}

</aside>

### 사용자 삭제 API

<aside>
💡 [DELETE] /destroy/:user_id

</aside>

User, UserGroup, Playlist 테이블에서 사용자 비활성화 (논리 삭제)

---

### 음악 검색 및 정렬 API

<aside>
💡 **[GET]** /musics?keyword=&sortby=

</aside>

keyword: 검색어 

sortby: 정렬 기준 (최신순, 인기순, 정확도순)

created_at 정렬 ⇒ 쿼리문 써서 따로 진행 

---

### 좋아요 표시 기능 API

<aside>
💡 **[POST]** /likes

body : {
    music_id: number,
    user_id: number,
}

</aside>

---

### 플레이리스트 생성 API

<aside>
💡 **[POST]** /playlists/:id

body :{
    ownable_type: varchar,
}

</aside>

ownable_type: person or group ⇒ parsing 후 오브젝트로 ownable 에 넘겨줌

### 플레이리스트 음악 조회 API

<aside>
💡 **[GET]** /playlists/:playlist_id (개별 플리 조회)

</aside>

ownable type 을 통해 그룹 플레이리스트인지 개인 플레이리스트인지 알 수 있음

### 플레이리스트 음악 추가 API (1개 및 N개)

<aside>
💡 **[PATCH]** /playlists/:playlist_id

body : {
    user_id: number
    musics_id: number array,
}

</aside>

user_id 를 쓴 이유: 사실 person playlist 면 없어도 되는데 그룹 플레이리스트 추가 할 때 누가 추가했는지 정보가 필요해서

### 플레이리스트 음악 제거 API (1개 및 N개)

<aside>
💡 **[DELETE]** /playlists/:playlist_id

body : {
    musics_id: number array,
}

</aside>

*bulkDelete

---

### 새로운 그룹 생성

<aside>
💡 **[POST]** /groups/create 

body : {
    users_id: number array,
    group_name: string
}

</aside>

group name 을 바탕으로 Group 모델에 인스턴스를 생성하고, 받은 users_id 배열을 바탕으로 UserGroup 모델에 group_id 와 user_id 를 추가해줌

### 그룹원 확인

<aside>
💡 [GET] /groups/:group_id

</aside>

### 기존 그룹에 인원 추가

<aside>
💡 **[POST]** /groups/add_member

body: {
    users_id: number array,
    group_id: number
}

</aside>

### 기존 그룹에 인원 삭제

<aside>
💡 **[DELETE]** /groups/destroy_member/:group_id

body : {
    users_id: number array,
}

</aside>

### 그룹 삭제

<aside>
💡 **[DELETE]** /groups/destroy_group/:group_id

</aside>

### 그룹 복구

<aside>
💡 **[PATCH]** /groups/recover_group/:group_id

</aside>