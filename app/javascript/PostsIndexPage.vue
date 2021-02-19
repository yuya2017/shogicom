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
          <!-- vue-routerに適応 -->
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
            <div class="card_summary d-lg-flex my-4 d-block">
              <div class="profile_main mx-2">
                <div v-on:click='profileDetails(post.id)' class="profile_img">
                  <img :src='post.user.user_image.url' class="icon_image" alt="アイコン">
                  <figcaption class="balloon-name-description">
                    <p>{{ post.user.user_name }}</p>
                    </figcaption>
                </div>
                <div class="card profile_link" v-bind:id="'profile' + post.id">
                  <div class="card-body profile_body">
                    <p class="card-text">よく使うアプリ：{{ post.user.user_app }}</p>
                    <p class="card-text">棋力：{{ post.user.user_chess }}</p>
                    <p class="card-text">よく対戦する持ち時間：{{ post.user.user_time }}</p> 
                    <a :href="'/tops/'+post.user.id" class="card-link profile_btn">プロフィール</a>
                    <a v-if="user && user.id!=post.user.id" class="card-link profile_btn" rel="nofollow" data-method="post" :href="'/rooms/create_private_room?user_id='+post.user.id">個人用チャットルーム</a>
                  </div>
                </div>
              </div>
              <div class="post_box_outer">
                <router-link :to="{ name: 'PostsShowPage', params: { id: post.id } }">
                  <div class="post_box">
                    <span v-if="post.post_all_tag.length" v-for="tag in splitJoin(post.post_all_tag)" v-text="tag" class="tag_text mr-2"></span>
                    <p>対戦したいアプリ：{{ post.post_app }}</p>
                    <p>棋力：{{ post.post_chess }}</p>
                    <p>持ち時間：{{ post.post_time }}</p>
                    <p>募集内容</p>
                    <p>{{ post.post_content }}</p>
                    <p class="post_date">{{ post.created_at }}</p>
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
      posts: [],
      user: {}
    }
  },
  mounted () {
    Promise.all([
      axios.get(`/api/posts.json`),
      axios.get(`/api/users/user_signed_in`)
    ]).then( ([posts, user]) => {
      console.log(posts)
      this.posts = posts.data
      this.user = user.data
    })
  },
  components: {
    'topheader': Header,
    'searchbar': Search
  },
  methods: {
    profileDetails: function(id) {
      const profile_id = document.getElementById('profile'+ id)
      if (profile_id.style.display == 'block') {
        profile_id.style.display = 'none'
      } else {
        profile_id.style.display = 'block'
      }
    },
    splitJoin: function(theText) {
      return theText.split(",")
    }
  },

}
</script>

<style scoped>

</style>