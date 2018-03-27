<!-- The ref attr used to find the swiper instance -->
<template>
  <div class="swiper-box">
    <swiper :options="swiperOption" ref="mySwiper" class="swiper-box">
      <!-- slides -->
      <swiper-slide class="swiper-item">
        <a href="http://alongwy.top/blog"><span style="font-size: xx-large; color: white; ">欢迎光临寒舍</span></a>
        <img src="/static/WallPaper.jpg">
      </swiper-slide>
      <!--<swiper-slide class="swiper-item">-->
      <!--</swiper-slide>-->
      <!--<swiper-slide class="swiper-item">-->
      <!--</swiper-slide>-->
      <!--<swiper-slide class="swiper-item">-->
      <!--</swiper-slide>-->
      <!-- Optional controls -->
      <div class="swiper-pagination" slot="pagination"></div>
      <div class="swiper-scrollbar" slot="scrollbar"></div>
    </swiper>
  </div>
</template>

<script>
export default {
  name: 'carrousel',
  data () {
    return {
      swiperOption: {
        pagination: {
          el: '.swiper-pagination',
          dynamicBullets: true
        }
      }
    }
  },
  mounted () {
    console.log('this is current swiper instance object', this.swiper)
    this.swiper.slideTo(3, 1000, false)
  }
}
</script>

<style scoped>
  html, body {
    position: relative;
    height: 100%;
  }

  body {
    background: #eee;
  }

  .swiper-box {
    width: 100%;
    height: 100%;
    margin: 0 auto;
    position: absolute;
    left: 0;
    top: 0;
    right: 0;
    bottom: 0;
  }

  .swiper-item {
    height: 100%;
    width: 100%;
    text-align: center;
    font-size: 18px;
    background: #fff;
    /* Center slide text vertically */
    display: -webkit-box;
    display: -ms-flexbox;
    display: -webkit-flex;
    display: flex;
    -webkit-box-pack: center;
    -ms-flex-pack: center;
    -webkit-justify-content: center;
    justify-content: center;
    -webkit-box-align: center;
    -ms-flex-align: center;
    -webkit-align-items: center;
    align-items: center;
    z-index: -2;
  }

  img {
    width: 100%;
    min-height: 100%;
    vertical-align: middle;
    position: absolute;
    z-index: -1;
  }
</style>
