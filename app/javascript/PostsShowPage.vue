<template>
  <div id="app">
   <topheader></topheader>
   <div class="container">
    <div class="row">
      <div class="col-lg-9 order-lg-last header_next show_media">
        <div class="show_box_outer">
          <div class="post_box">
            <h4>{{ post.room.room_name }}</h4>
            <!-- <% all_tags = @post.post_all_tag.split(",") %>
            <% all_tags.each do |all_tag| %> -->
              <span class="tag_text">#{{ post.all_tag }}</span>
            <p>対戦したいアプリ：{{ post.post_app }}</p>
            <p>棋力：{{ post.post_chess }}</p>
            <p>持ち時間：{{ post.post_time }}</p>
            <p>募集内容</p>
            <p>{{ post.post_content }}</p>
            <p class="post_date">{{ post.created_at }}</p>
            <!-- <p class="post_date"><%= l @post.created_at, format: '%-m月%-d日(%a) %H:%M' %></p> -->
          </div>
        </div>
        <div class="post_message_link">
          <!-- <a href="/rooms/#{@room.id}/post" class="btn btn-primary buttonConfirm">チャットルームへ移動</a> -->
          <router-link :to="{ name: 'RoomsIndexPage', params: { id: post.room.id } }" class="btn btn-primary buttonConfirm">
            チャットルームへ移動
          </router-link>
        </div>
      </div>
      <div class="col-lg-3 header_next">
        <p class="text-center">投稿者</p>
        <div class="prifile_img text-center">
          <img src='#' class="icon_no_link mb-4" alt="ユーザーアイコン">
          <p>{{ post.user.user_name }}</p>
        </div>
        <!-- <% if user_signed_in? && @post.user_id == current_user.id %> -->
          <div class="side_user_edit">
            <router-link :to="{ name: 'PostsEditPage', params: { id: post.id }}" class="btn-circle-3d">編集</router-link>
            
            <!-- <a href="/posts/#{@post.id}/edit" class="class: "btn-circle-3d"">編集</a>> -->
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import Header from './packs/components/header.vue';

export default {
  data: function () {
    return {
      post: {}
    }
  },
  mounted () {
    axios
      .get(`/api/posts/${this.$route.params.id}.json`)
      .then(response => (this.post = response.data))
  },
    components: {
    'topheader': Header,
  }
}
</script>

<style scoped>

</style>