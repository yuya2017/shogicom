document.addEventListener('turbolinks:load', () => {
  let map;
  let geocoder;
  let marker = [];
  let infoWindow = [];
  const user_pref = gon.user_pref;
  const communities = gon.communities;


  function initMap(){
    geocoder = new google.maps.Geocoder()
    map = new google.maps.Map(document.getElementById('map'), {
      center: {lat: 35.5040528, lng: 138.6485391},
      zoom: 8.7
    });

    geocoder.geocode( { 'address': user_pref }, function(results, status) {
      if (status == 'OK') {
        map.setCenter(results[0].geometry.location)
      };
    });

    for (let i = 0; i < communities.length; i++) {
      geocoder.geocode( { 'address': communities[i].community_place }, function(results, status) {
        if (status == 'OK') {
          marker[i] = new google.maps.Marker({
            map: map,
            position: results[0].geometry.location
          });
          let id = communities[i]['id']
          let infoWindowContent = `<a href='/communities/${id}' data-turbolinks="false" class="marker-${id}" ><p class="gmap_info_window_date">開催日：${communities[i].community_date}</p><p class="gmap_info_window_limit">応募期間：${communities[i].community_limit}</p><p class="gmap_info_window_money">参加費：${communities[i].community_money}</p><p class="gmap_info_window_address">${communities[i].community_place}</p></a>`;

          infoWindow[i] = new google.maps.InfoWindow({
            content: infoWindowContent
          });
          marker[i].addListener("click", function(){
            infoWindow[i].open(map, marker[i]);
          });
        };
      });
    };
  };
  window.onload = function () {
      initMap();
  };
});
