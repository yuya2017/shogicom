<template>
  <div id="app">
   <topheader></topheader>
  </div>
</template>

<script>
import axios from 'axios';
import Header from './packs/components/header.vue';

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
  }
}
</script>

<style scoped>

</style>