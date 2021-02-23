<template>
  <div id="app">
   <topheader></topheader>
   <div class="container">
    <div class="row">
      <div class="col-lg-9 order-lg-last header_next show_media">
        <div class="show_box_outer">
          <div class="post_box">
            <h4>{{ tournament.room.room_name }}</h4>
            <span v-if="tournament.tournament_all_tag.length" v-for="tag in splitJoin(tournament.tournament_all_tag)" v-text="tag" class="tag_text mr-2"></span>
            <p class="tournament_date">開催日時：{{ tournament.tournament_limit}}</p>
            <p>応募期間：{{ tournament.tournament_date }}<p>
            <p v-if="tournament.tournament_number_of_people">応募人数:{{ tournament.tournament_number_of_people }}</p>
            <p>対戦したいアプリ：{{ tournament.tournament_app }}</p>
            <p>棋力：{{ tournament.tournament_chess }}</p>
            <p>持ち時間：{{ tournament.tournament_time }}</p>
            <p>募集内容</p>
            <p>{{ tournament.tournament_content }}</p>
            <p class="post_date">{{ tournament.created_at }}</p>
          </div>
        </div>
        <div class="post_message_link">
          <router-link :to="{ name: 'RoomsIndexPage', params: { id: tournament.room.id } }" class="btn btn-primary buttonConfirm">
            チャットルームへ移動
          </router-link>
        </div>
      </div>
      <div class="col-lg-3 header_next">
        <p class="text-center">投稿者</p>
        <div class="prifile_img text-center">
          <img :src='tournament.user.user_image.url' class="icon_no_link mb-4" alt="アイコン">
          <p>{{ tournament.user.user_name }}</p>
        </div>
        <div class="side_user_edit" v-if="user && user.id==tournament.user.id">
          <router-link :to="{ name: 'TournamentsEditPage', params: { id: tournament.id }}" class="btn-circle-3d">編集</router-link>
        </div>
        <div class="side_user_edit" v-else-if="user && tournament.user_id">
          <a class="btn-circle-3d exit_color" data-confirm="本当に抜けますか？" rel="nofollow" data-method="post" :href="'/tournaments/tournament_exit?tournament='+tournament.id">退出</a>
        </div>
        <p class="text-center">この大会に参加するユーザー</p>
        <table class="table table-striped">
          <thead>
            <tr>
              <th scope="col">人数</th>
              <th scope="col">名前</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(tournament_user, index) in participantUser(tournament_users, tournament.id, users)" :key=tournament_user.id>
              <th scope="row">{{ index + 1 }}</th>
              <td>{{ tournament_user.user_name }}</td>
            </tr>
          </tbody>
        </table>
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
      tournament: {},
      user: {},
      tournament_users: [],
      users: []
    }
  },
  mounted () {
    Promise.all([
      axios.get(`/api/tournaments/${this.$route.params.id}.json`),
      axios.get(`/api/users/user_signed_in`),
      axios.get('api/tournament_users'),
      axios.get('api/users')
    ]).then( ([tournament, user, tournament_users, users]) => {
      this.tournament = tournament.data
      this.user = user.data
      this.tournament_users = tournament_users.data
      this.users = users.data
    })
  },
  components: {
    'topheader': Header,
  },
  methods: {
    splitJoin: function(theText) {
      return theText.split(",")
    },
    participantUser: function(tournament_users, tournament, users) {
      const tournamentObject = tournament_users.filter(ｖ => ｖ.tournament_id == tournament);
      var result = []
      tournamentObject.forEach(element => {
        result.push(users.find((v) => v.id == element.user_id));
      });
      return result
    }
  }
}
</script>

<style scoped>

</style>