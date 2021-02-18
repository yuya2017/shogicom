<template>
  <div id="app">
   <topheader></topheader>
		<div class="container-fluid">
			<div class="row">
				<sidebar></sidebar>
				<main class="col-lg-9 px-4 ml-auto">
					<h1 class="heading">編集</h1>
					<div class="inputInformation">
						<p>下記の内容をご入力の上、お進みください。</p>
					</div>
					<form>
					<!-- <%= form_with model: @post, local: true do |f| %> -->
						<!-- <% if @post.errors.any? %>
							<div id="error_explanation">
								<h3 style="color:red;">
									<%= I18n.t("errors.messages.not_saved",
														count: @post.errors.count,
														resource: @post.class.model_name.human.downcase)
									%>
								</h3>
								<ul>
									<% @post.errors.full_messages.each do |message| %>
									<li><%= message %></li>
									<% end %>
								</ul>
							</div>
						<% end %> -->
						<!-- <%= f.fields_for :room do |i| %> -->
							<div class="form-group">
								<label for="room_name">部屋名*</label>
								<input type="text" class="form-control" :value=post.room.room_name>
								<!-- <%= i.label :room_name, '部屋名*' %>
								<%= i.text_field :room_name, class: 'form-control'%> -->
								<small class="form-text text-muted">
									投稿ごとにチャットルームを持つことができます。
								</small>
							</div>
						<!-- <% end %> -->
						<div class="form-group">
							<label for="post_chess">棋力*</label>
							<input type="text" class="tagsinput" :value=post.post_chess>
							<!-- <%= f.label :post_chess, '棋力*' %> -->
							<!-- <%= f.text_field :post_chess, class: 'tagsinput',value: current_user.user_chess %> -->
							<small class="form-text text-muted">
								自分の推定棋力を入力してください。
							</small>
						</div>
						<div class="form-group">
							<label for="post_app">使用するアプリ*</label>
							<input type="text" class="tagsinput" :value=post.post_app>
							<!-- <%= f.label :post_app, '使用するアプリ*' %>
							<%= f.text_field :post_app, class: 'tagsinput',value: current_user.user_app %> -->
							<small class="form-text text-muted">
								希望するアプリを入力してください。
							</small>
						</div>
						<div class="form-group">
							<label for="post_time">対戦時間*</label>
							<input type="text" class="tagsinput" :value=post.post_time>
							<!-- <%= f.label :post_time, '対戦時間*' %>
							<%= f.text_field :post_time, class: 'tagsinput',value: current_user.user_time %> -->
							<small class="form-text text-muted">
								希望する対戦時間を入力してください。
							</small>
						</div>
						<div class="form-group">
							<label for="post_all_tag">タグ</label>
							<input type="text" class='tagsinput' :value=post.post_all_tag>
							<!-- <%= f.label :post_all_tag, 'タグ' %>
							<%= f.text_field :post_all_tag, class: 'tagsinput'%> -->
							<small class="form-text text-muted">
								好きなタグをつけることができます。
							</small>
						</div>
						<div class="form-group">
							<label for="post_content">募集内容</label>
							<input type="textarea" class='form-control' :value=post.post_content>
							<!-- <%= f.label :post_content, '募集内容' %>
							<%= f.text_area :post_content, class: 'form-control'%> -->
							<small class="form-text text-muted">
								募集内容を入力してください。
							</small>
						</div>
						<div class="buttonContainer">
							<button class="btn btn-primary buttonConfirm">編集</button>
							<!-- <%= f.submit '編集', class: 'btn btn-primary buttonConfirm' %> -->
						</div>
					</form>
					<div class="buttonContainer">
						<!-- <%= link_to '削除', "/posts/#{@post.id}", method: :delete, class:"btn btn-danger buttondestroy", data: {confirm: "削除しますか？"} %> -->
					</div>
				</main>
			</div>
		</div>
  </div>
</template>

<script>
import axios from 'axios';
import Header from './packs/components/header.vue';
import Sidebar from './packs/components/sidebar.vue';

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
    'sidebar': Sidebar
  }
}
</script>

<style scoped>

</style>