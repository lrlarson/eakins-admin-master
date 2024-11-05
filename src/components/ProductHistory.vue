<template>
	<v-container>
		<v-layout row wrap align-center>
			<v-flex>
				<v-card>
					<v-card-title class="justify-center">
						Product History <br />
						{{historyArray[0].ITEMNAME}}
					</v-card-title>
				</v-card>
			</v-flex>
		</v-layout>
		<vue-json-to-csv
				:json-data="historyArray"
				:csv-title ="startDateString"
				:labels="{
    NAME: { title: 'Name' },
    ITEMS__ITEMS__TOTALPRICE: { title:'$ Amount' },
    DATE:{title:'Last Date'},
    

  }"
		>
			<v-btn color="green" style="margin-top: 20px;">
				<b>Download as Comma-Delimited CSV File</b>
			</v-btn>
		</vue-json-to-csv>
		<v-layout row wrap>
			<v-container grid-list-md>
				Click for Customer Orders
				<v-data-table
						:headers="headers"
						:items="historyArray"
						:items-per-page="1000"
						class="elevation-1"
						@click:row="handleClick"
						:dense="true"
						:search="search"
						:custom-filter="filterOnlyCapsText">
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
import VueJsonToCsv from 'vue-json-to-csv'
import axios from "axios";
import router from "@/router";
import moment from "moment";
export default {
	components:{
		VueJsonToCsv
	},
	name: "ProductHistory" ,
	data: () => ({
		dataURL: "https://eakinspress.com/data/data/eakinsAdmin.cfc?",
		search: "",
		detailMode:false,
		product_ID:'',
		historyArray:[],
		startDateString:'',
		printDate:'',
		headers: [
			{
				text: "Name",
				value: "NAME",
				sortable: true
			},
			{text:"Amount",value: "ITEMS__ITEMS__TOTALPRICE",sortable: true} ,
			{ text: "Date", value: "DATE", sortable: true },
		],
	}),
	methods:{
		getHistory(){
			let vm=this;
			axios.get(vm.dataURL + 'method=getProductHistory&product_ID=' + vm.product_ID)
					.then(function (results){
						vm.historyArray = results.data.results;
						let currentDate = moment();
						vm.printDate =  moment(currentDate).format("MM-DD");
						vm.startDateString = 'report-date ' + vm.printDate;
					})
		},
		handleClick(value){
			router.push({ name: "CustomerOrders", params: { snipcart_ID: value.SNIPCART_ID } });
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
		this.product_ID= this.$route.params.product_ID;
		this.getHistory();
	}
}
</script>

<style scoped>

</style>
