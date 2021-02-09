<template>
  <div id="app">
    <h1>実験</h1>
  </div>
</template>

<script>
import axios from 'axios';

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
  }
}
</script>

<style scoped>

</style>