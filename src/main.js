import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import CKEditor from '@ckeditor/ckeditor5-vue2';
import axios from 'axios'
import VueAxios from 'vue-axios'
import Toast from 'vue-easy-toast'
import VueGlobalVariable from "vue-global-var";
import User from './model/User';
import vuetify from './plugins/vuetify'



Vue.config.productionTip = false

Vue.use( CKEditor );
Vue.use(Toast);
Vue.use(VueAxios, axios) ;
Vue.use(VueGlobalVariable, {
  globals: {
    $user: new User("user1")
  }
});

window.$ = window.jQuery = require('jquery');

export const eventBus = new Vue ({
  methods:{
    signedIn: function () {
      this.$root.$emit('signedIn')
      this.$emit('signedIn');
    }

  },

  store,
  vuetify,

  data:function(){
    return {
      authenticated:false

    }
  }
})

new Vue({
  router,
  store,
  vuetify,
  render: h => h(App)
}).$mount('#app')
