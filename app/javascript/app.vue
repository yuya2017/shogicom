<template>
  <div>
    <router-view></router-view>
  </div>
</template>

<script>
import Vue from 'vue'
import VueRouter from 'vue-router'

import TopsIndexPage from 'TopsIndexPage.vue'
import PostsIndexPage from 'PostsIndexPage.vue'
import PostsShowPage from 'PostsShowPage.vue'
import PostsEditPage from 'PostsEditPage.vue'
import TournamentsIndexPage from 'TournamentsIndexPage.vue'
import TournamentsShowPage from 'TournamentsShowPage.vue'
import TournamentsEditPage from 'TournamentsEditPage.vue'
import CommunitiesIndexPage from 'CommunitiesIndexPage.vue'
import RoomsIndexPage from 'RoomsIndexPage.vue'

const router = new VueRouter({
  routes: [
    { path: '/',
      name: 'TopsIndexPage',
      component: TopsIndexPage },
    { path: '/posts',
      name: 'PostsIndexPage',
      component: PostsIndexPage },
    { path: '/posts/:id(\\d+)',
      name: 'PostsShowPage',
      component: PostsShowPage },
    { path: '/posts/:id(\\d+)/edit',
      name: 'PostsEditPage',
      component: PostsEditPage },
    { path: '/Tournaments',
      name: 'TournamentsIndexPage',
      component: TournamentsIndexPage },
    { path: '/Tournaments/:id(\\d+)',
      name: 'TournamentsShowPage',
      component: TournamentsShowPage },
    { path: '/Tournaments/:id(\\d+)/edit',
      name: 'TournamentsEditPage',
      component: TournamentsEditPage },
    { path: '/Communities',
      name: 'CommunitiesIndexPage',
      component: CommunitiesIndexPage },
    { path: '/rooms/:id(\\d+)',
      name: 'RoomsIndexPage',
      component: RoomsIndexPage },
  ]
})


Vue.use(VueRouter)

export default {
  router
}
</script>

<style scoped>
</style>