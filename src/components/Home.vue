<template>
	<v-container >
		<v-row >
			<v-col  >
				<v-btn block elevation="14" color="accent"  x-large @click="goToBooks">Books</v-btn>
			</v-col>
			<v-col>
				<v-btn block elevation="14" color="accent"  x-large @click="goToDanceIndex">Dance Index</v-btn>
			</v-col>
			<v-col>
				<v-btn block elevation="14" color="accent"  x-large @click="goToHomePageSettings">Home Page Settings</v-btn>
			</v-col>
			<v-col>
				<v-btn block elevation="14" color="accent"  x-large @click="goToDanceIndexPurchases">Dance Index Purchases</v-btn>
			</v-col>
			<v-col>
				<v-btn block elevation="14" color="accent"  x-large @click="goToGeneralCustomers">General Customers</v-btn>
			</v-col>
			
		</v-row>
	</v-container>
</template>

<script>
import router from "../router";
export default {
	name: "Home",
	methods: {
		goToBooks(){
			router.push({name:'Books'});
		},
		goToDanceIndex(){
			router.push({name:'DanceIndex'});
		},
		goToHomePageSettings(){
			router.push({name:'FrontPageControl'});
		},
		goToDanceIndexPurchases(){
			router.push({name:'DanceIndexPurchases'});
		},
		goToGeneralCustomers(){
			router.push({name:'Customers'});
		}
	}
}
</script>

<style scoped>

</style>
