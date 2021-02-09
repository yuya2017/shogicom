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
import TournamentsIndexPage from 'TournamentsIndexPage.vue'
import CommunitiesIndexPage from 'CommunitiesIndexPage.vue'

const router = new VueRouter({
  routes: [
    { path: '/',
      component: TopsIndexPage  },
    { path: '/posts',
      name: 'PostsIndexPage',
      component: PostsIndexPage  },
    { path: '/Tournaments',
      name: 'TournamentsIndexPage',
      component: TournamentsIndexPage  },
    { path: '/Communities',
      name: 'CommunitiesIndexPage',
      component: CommunitiesIndexPage  },
  ]
})


Vue.use(VueRouter)

export default {
  router
}
</script>

<style scoped>
</style>