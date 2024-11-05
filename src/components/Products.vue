<template>
	<v-container>
		<v-layout row wrap align-center>
			<v-flex>
				<v-card>
					<v-card-title class="justify-center">
						Web Sold Products
					</v-card-title>
				</v-card>
			</v-flex>
		</v-layout>
		
		<v-layout row wrap>
			<v-container grid-list-md>
				<v-data-table
						:headers="headers"
						:items="productsArray"
						:items-per-page="1000"
						class="elevation-1"
						@click:row="handleClick"
						:dense="true"
						:search="search"
						:custom-filter="filterOnlyCapsText"
				>
					<template v-slot:top>
						<v-text-field
								v-model="search"
								label="Search (UPPER CASE ONLY)"
								class="mx-4"
						></v-text-field>
					</template>
				</v-data-table>
			</v-container>
		</v-layout>
	</v-container>
</template>

<script>
import axios from "axios";
import router from "../router";
export default {
	name: "Customers" ,
	data: () => ({
		dataURL: "https://eakinspress.com/data/data/eakinsAdmin.cfc?",
		search: "",
		detailMode:false,
		productsArray:[],
		headers: [
			{
				text: "Name",
				value: "NAME",
				sortable: true
			},
			{ text: "Price", value: "PRICE", sortable: true },
			{text:"Count",value: "COUNT",sortable: true},
		],
	}),
	methods:{
		getProducts(){
			let vm=this;
			axios.get(vm.dataURL + 'method=getProducts')
					.then(function (results){
						vm.productsArray = results.data.results;
					})
		},
		handleClick(value){
			router.push({ name: "ProductHistory", params: { product_ID: value.ITEMS__ITEMS__ID } });
		},
		filterOnlyCapsText(value, search) {
			return (
					value != null &&
					search != null &&
					typeof value === "string" &&
					value
							.toString()
							.toLocaleUpperCase()
							.indexOf(search) !== -1
			);
		},
	},
	mounted() {
		this.getProducts();
	}
}
</script>

<style scoped>

</style>
