<template>
  <div id="app">
   <topheader></topheader>
    <div class="container-fluid">
      <div class="row">
        <searchbar></searchbar>
        <div class="col-lg-9 px-4 ml-auto order-1">
          <div class="heading">
            <h2>対戦</h2>
          </div>
          <fieldset class="d-block d-lg-none post_choice">
            <input id="item-1" class="radio-inline__input" type="radio" name="accessible-radio" value="/posts" onclick="location.href=this.value" checked="checked"/>
            <label class="radio-inline__label" for="item-1">
                対戦
            </label>
            <input id="item-2" class="radio-inline__input" type="radio" name="accessible-radio" onclick="location.href=this.value" value="/tournaments"/>
            <label class="radio-inline__label" for="item-2">
                大会
            </label>
            <input id="item-3" class="radio-inline__input" type="radio" name="accessible-radio" value="/communities" onclick="location.href=this.value"/>
            <label class="radio-inline__label" for="item-3">
                イベント
            </label>
          </fieldset>
        </div>
        <div class="col-lg-9 px-4 ml-auto order-3">
          <div v-for="post in posts" :key="post.id">
            <p>{{ post.id }}</p>
            <div class="card_summary d-lg-flex my-4 d-block">
              <div class="profile_main mx-2">
                <div class="profile_img">
                  <!-- data-idはpost.id, srcに投稿者の画像 -->
                  <img src='#' class="icon_image" alt="アイコン" data-id="post-1">
                  <figcaption class="balloon-name-description">
                    <p>{{ post.user.user_name }}</p>
                    </figcaption>
                </div>
                <div class="card profile_link profile-post-<%= post.id %>">
                  <div class="card-body profile_body">
                    <p class="card-text">よく使うアプリ：{{ post.user.user_app }}</p>
                    <p class="card-text">棋力：{{ post.user.user_chess }}</p>
                    <p class="card-text">よく対戦する持ち時間：{{ post.user.user_time }}</p>
                    <!-- 自分以外の投稿の場合 
                      <%= link_to '個人用チャットルーム', rooms_create_private_room_path(:user_id => post.user_id), class: "card-link profile_btn", method: :post  %>
                    -->
                    <a href="/tops/1" class="card-link profile_btn">プロフィール</a>
                    <a href="/tops/1" class="card-link profile_btn">個人用チャットルーム</a>
                  </div>
                </div>
              </div>
              <div class="post_box_outer">
                <router-link :to="{ name: 'PostsShowPage', params: { id: post.id } }">
                <!-- クラスにpost.idを付与する<%= link_to "/posts/#{post.id}", class: "post-#{post.id}" do %> -->
                  <div class="post_box">
                    <!-- <% all_tags = post.post_all_tag.split(",") %> -->
                    <!-- <% all_tags.each do |all_tag| %> -->
                      <span class="tag_text">#{{ post.all_tag }}</span>
                    <!-- <% end %> -->
                    <p>対戦したいアプリ：{{ post.post_app }}</p>
                    <p>棋力：{{ post.post_chess }}</p>
                    <p>持ち時間：{{ post.post_time }}</p>
                    <p>募集内容</p>
                    <p>{{ post.post_content }}</p>
                    <p class="post_date">{{ post.created_at }}</p>
                    <!-- <p class="post_date"><%= l post.created_at, format: '%-m月%-d日(%a) %H:%M' %></p> -->
                  </div>
                </router-link>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import Header from './packs/components/header.vue';
import Search from './packs/components/posts/search.vue';

export default {
  data: function () {
    return {
      posts: []
    }
  },
  mounted () {
    axios
      .get('/api/posts.json')
      .then(response => (this.posts = response.data))
  },
    components: {
    'topheader': Header,
    'searchbar': Search
  }
}
</script>

<style scoped>

</style>