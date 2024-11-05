<template>
	<v-container>
		<v-container grid-list-md text-xs-center>
			<v-card-text class="page-title">Sign In</v-card-text>
			<v-text-field v-model="email" label="email"></v-text-field>
			<v-text-field
					v-model="pword"
					label="password"
					type="password"
			></v-text-field>
			<v-btn color="success" @click="signIn">Click</v-btn>
			
			<v-card-text>{{ secureMessage }}</v-card-text>
		</v-container>
	</v-container>
</template>

<script>
import {eventBus} from "@/main";
import store from "@/store";
 import axios from "axios";
import router from "../router";



export default {
	data: () => ({
		dataURL: "https://eakinspress.com/data/data/eakinsAdmin.cfc?",
		email: "",
		pword: "",
		secureMessage: ""
	}),
	name: "SignIn" ,
	methods:{
		signIn: function() {
			var vm = this;
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				data: {
					method: "checkSecure",
					email: vm.email,
					pword: vm.pword
				},
				success: function(d){
					if (d.results.length > 0) {
						eventBus.$emit("signedIn");
						vm.mutateAuthentication();
						vm.secureMessage = "logged in";
						vm.$user.copy({
							name: vm.email,
							logged:true
						})
						vm.logInUser();
						console.log(vm.$user.name,vm.$user.logged);
						router.push({name:'Home'});
					} else {
						eventBus.$emit("signInFail");
						vm.secureMessage = "incorrect login";
					}
				},
				error: function (e) {
					console.log(e);
				}
			});
		},
		saveNewClass(){
			var vm = this;
			vm.classObject.CLASSDATE = vm.picker;
			window.$.ajax({
				type: "post",
				url: "https://johncage.org/data/merce-data.cfc",
				dataType: "json",
				data: {
					method: "insertNewClass",
					classObject: JSON.stringify(vm.classObject)
				},
				success: function () {
					console.log('success');
					vm.getClasses();
					vm.clearClassObjects();
					vm.newClassMode = false;
					
					
				},
				error: function (jqXHR, exception) {
					var msg = "";
					if (jqXHR.status === 0) {
						msg = "Not connect.\n Verify Network.";
					} else if (jqXHR.status == 404) {
						msg = "Requested page not found. [404]";
					} else if (jqXHR.status == 500) {
						msg = "Internal Server Error [500].";
					} else if (exception === "parsererror") {
						msg = "Requested JSON parse failed.";
					} else if (exception === "timeout") {
						msg = "Time out error.";
					} else if (exception === "abort") {
						msg = "Ajax request aborted.";
					} else {
						msg = "Uncaught Error.\n" + jqXHR.responseText;
					}
					alert(msg);
				}
			});
			
			
		},
		mutateAuthentication(){
			store.commit("makeAuthenticated");
		},
		logInUser(){
			let vm = this;
			axios.get(vm.dataURL+ 'method=logInUser&user=' + vm.email);
		}
	}
}
</script>

<style scoped>

</style>

