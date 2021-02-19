<template>
  <div id="app">
   <topheader></topheader>
   <div class="container">
    <div class="row">
      <div class="col-lg-9 order-lg-last header_next show_media">
        <div class="show_box_outer">
          <div class="post_box">
            <h4>{{ post.room.room_name }}</h4>
            <span v-if="post.post_all_tag.length" v-for="tag in splitJoin(post.post_all_tag)" v-text="tag" class="tag_text mr-2"></span>
            <p>対戦したいアプリ：{{ post.post_app }}</p>
            <p>棋力：{{ post.post_chess }}</p>
            <p>持ち時間：{{ post.post_time }}</p>
            <p>募集内容</p>
            <p>{{ post.post_content }}</p>
            <p class="post_date">{{ post.created_at }}</p>
          </div>
        </div>
        <div class="post_message_link">
          <router-link :to="{ name: 'RoomsIndexPage', params: { id: post.room.id } }" class="btn btn-primary buttonConfirm">
            チャットルームへ移動
          </router-link>
        </div>
      </div>
      <div class="col-lg-3 header_next">
        <p class="text-center">投稿者</p>
        <div class="prifile_img text-center">
          <img :src='post.user.user_image.url' class="icon_no_link mb-4" alt="アイコン">
          <p>{{ post.user.user_name }}</p>
        </div>
          <div class="side_user_edit" v-if="user && user.id==post.user.id">
            <router-link :to="{ name: 'PostsEditPage', params: { id: post.id }}" class="btn-circle-3d">編集</router-link>
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
      post: {},
      user: []
    }
  },
  mounted () {
    Promise.all([
      axios.get(`/api/posts/${this.$route.params.id}.json`),
      axios.get(`/api/users/user_signed_in`)
    ]).then( ([post, user]) => {
      this.post = post.data
      this.user = user.data
    })
  },
  components: {
    'topheader': Header,
  },
  methods: {
    splitJoin: function(theText) {
      return theText.split(",")
    }
  }
  
}
</script>

<style scoped>

</style>