<template>
  <header>
    <div class="header_body">
      <div class="header-icon">
        <a href="/">
          <img src="/img/logo.jpg" alt="ノシ将棋" class="logo">
        </a>
      </div>
      <div class="d-none d-lg-block">
        <a href="/posts" class="header_search">対戦相手を探す</a>
        <a href="/tournaments" class="header_search">大会を探す</a>
        <a href="/communities" class="header_search" data-turbolinks='false'>イベントを探す</a>
      </div>
      <div class="header_mypage d-flex">
        <div class="dropdown header_icon">
          <a href="#" id="DropdownMenuLink" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-edit fa-2x mx-4"></i>
          </a>
          <div class="dropdown-menu" aria-labelledby="DropdownMenuLink">
            <a href="/posts/new" class="dropdown-item">対戦</a>
            <a href="/tournaments/new" class="dropdown-item">大会開催</a>
            <a href="/communities/new" class="dropdown-item" data-turbolinks='false'>イベント開催</a>
          </div>
        </div>
        <!-- ログインしているかしていないかで変える。
            画像も登録してあれがデータベースから、なければデフォルトの画像を取ってくる。
        -->
        <div>
          <a href="tops/1" class="tops_icon">
            <img src='#' class="header_image" alt="ユーザーアイコン">
          </a>
        </div>
        <!-- <div v-else>
          <a href="#" class="mx-2">新規登録</a>
          <a href="#" class="mx-2">ログイン</a>
        </div> -->
      </div>
    </div>
  </header>
</template>