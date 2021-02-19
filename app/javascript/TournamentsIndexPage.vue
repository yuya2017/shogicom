<template>
  <div id="app">
   <topheader></topheader>
    <div class="container-fluid">
      <div class="row">
        <searchbar></searchbar>
        <div class="col-lg-9 px-4 ml-auto order-1">
        <div class="heading">
            <h2>大会</h2>
        </div>
        <fieldset class="d-block d-lg-none post_choice">
            <input id="item-1" class="radio-inline__input" type="radio" name="accessible-radio" value="/posts" onclick="location.href=this.value"/>
            <label class="radio-inline__label" for="item-1">
                対戦
            </label>
            <input id="item-2" class="radio-inline__input" type="radio" name="accessible-radio" onclick="location.href=this.value" value="/tournaments" checked="checked"/>
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
          <div v-for="tournament in tournaments" :key="tournament.id">
              <!-- tournament_number_of_people_limitが超えている場合は除外(Railsで処理) -->
            <div class="card_summary d-lg-flex my-4 d-block">
              <div class="profile_main mx-2">
                <div v-on:click='profileDetails(tournament.id)' class="profile_img">
                  <img :src='tournament.user.user_image.url' class="icon_image" alt="アイコン">
                  <figcaption class="balloon-name-description">
                    <p>{{ tournament.user.user_name }}</p>
                    </figcaption>
                </div>
                <div class="card profile_link" v-bind:id="'profile' + tournament.id">
                  <div class="card-body profile_body">
                    <p class="card-text">よく使うアプリ：{{ tournament.user.user_app }}</p>
                    <p class="card-text">棋力：{{ tournament.user.user_chess }}</p>
                    <p class="card-text">よく対戦する持ち時間：{{ tournament.user.user_time }}</p> 
                    <a :href="'/tops/'+tournament.user.id" class="card-link profile_btn">プロフィール</a>
                    <a v-if="user    && user.id!=tournament.user.id" class="card-link profile_btn" rel="nofollow" data-method="tournament" :href="'/rooms/create_private_room?user_id='+tournament.user.id">個人用チャットルーム</a>
                  </div>
                </div>
              </div>
              <div class="post_box_outer">
                <router-link :to="{ name: 'TournamentsShowPage', params: { id: tournament.id } }">
                  <div class="post_box">
                    <span v-if="tournament.tournament_all_tag.length" v-for="tag in splitJoin(tournament.tournament_all_tag)" v-text="tag" class="tag_text mr-2"></span>
                    <p class="tournament_date">開催日時：{{ tournament.tournament_date }}〜</p>
                    <p>応募期間：{{ tournament.tournament_limit }}まで</p>
                    <p v-if="tournament.tournament_number_of_people">応募人数：{{ tournament.tournament_number_of_people }}人</p>
                    <p>アプリ：{{ tournament.tournament_app }}</p>
                    <p>棋力：{{ tournament.tournament_chess }}</p>
                    <p>持ち時間：{{ tournament.tournament_time }}</p>
                    <p>募集内容</p>
                    <p>{{ tournament.tournament_content }}</p>
                    <p class="post_date">{{ tournament.created_at }}</p>
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
      tournaments: [],
      user: {}
    }
  },
  mounted () {
    Promise.all([
      axios.get(`/api/tournaments.json`),
      axios.get(`/api/users/user_signed_in`)
    ]).then( ([tournaments, user]) => {
      console.log(tournaments)
      this.tournaments = tournaments.data
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