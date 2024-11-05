import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    authenticated:false,
    searchByTitle: false,
    searchString: "",
    searchByAuthor: false,
    searchByPublisher: false,
    searchByCallNumber: false,
    searchByYear: false,
    searchByEditors: false,
    searchNotes: false,
    searchDetails: false,
    searchInternalNotes: false,
    searchByNewID: false
  },
  mutations: {
    makeAuthenticated(state){
      state.authenticated = true;
    },
    changeSearchByTitle(state) {
      if (state.searchByTitle === false) {
        state.searchByTitle = true;
      } else {
        state.searchByTitle = false;
      }
    },
    changeSearchByNewID(state) {
      if (state.searchByNewID === false) {
        state.searchByNewID = true;
      } else {
        state.searchByNewID = false;
      }
    },
    changeSearchString(state, searchString) {
      state.searchString = searchString;
    },
    changeSearchByAuthor(state) {
      if (state.searchByAuthor === false) {
        state.searchByAuthor = true;
      } else {
        state.searchByAuthor = false;
      }
    },
    changeSearchByPublisher(state) {
      if (state.searchByPublisher === false) {
        state.searchByPublisher = true;
      } else {
        state.searchByPublisher = false;
      }
    },
    changeSearchByCallNumber(state) {
      if (state.searchByCallNumber === false) {
        state.searchByCallNumber = true;
      } else {
        state.searchByCallNumber = false;
      }
    },
    changeSearchByYear(state) {
      if (state.searchByYear === false) {
        state.searchByYear = true;
      } else {
        state.searchByYear = false;
      }
    },
    changeSearchByEditors(state) {
      if (state.searchByEditors === false) {
        state.searchByEditors = true;
      } else {
        state.searchByEditors = false;
      }
    },
    changeSearchNotes(state) {
      if (state.searchNotes === false) {
        state.searchNotes = true;
      } else {
        state.searchNotes = false;
      }
    },
    changeSearchDetails(state) {
      if (state.searchDetails === false) {
        state.searchDetails = true;
      } else {
        state.searchDetails = false;
      }
    },
    changeSearchInternalNotes(state) {
      if (state.searchInternalNotes === false) {
        state.searchInternalNotes = true;
      } else {
        state.searchInternalNotes = false;
      }
    }
  },
  actions: {}
});
