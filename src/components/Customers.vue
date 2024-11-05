<template>
	<v-container>
		<v-layout row wrap align-center>
			<v-flex>
				<v-card>
					<v-card-title class="justify-center">
						General Customers   <div style="margin-left: 15px;"><v-btn color="blue" @click="addNewCustomer">Add New Customer</v-btn> </div>
					</v-card-title>
					
				</v-card>
			</v-flex>
		</v-layout>
		<vue-json-to-csv
				:json-data="customerArray"
				:csv-title ="startDateString"
				:labels="{
    NAME: { title: 'Name' },
    EMAIL: { title: 'Email' },
    ORDERCOUNT: { title: 'Order Count' } ,
   ORDERSAMOUNT:{title:'Orders Amount'} ,
    LASTDATE:{title:'Last Date'},
    ADDRESS_1:{title:'Address 1'},
     ADDRESS_2:{title:'Address 2'},
     CITY:{title:'City'},
      STATE:{title:'State'},
      ZIP:{title:'Zip'},
       COUNTRY:{title:'Country'},
  }"
		>
			<v-btn color="green" style="margin-top: 20px;">
				<b>Download as Comma-Delimited CSV File</b>
			</v-btn>
		</vue-json-to-csv>
		<v-layout row wrap>
			<v-container grid-list-md>
				<v-data-table
						:headers="headers"
						:items="customerArray"
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
import VueJsonToCsv from 'vue-json-to-csv'
import axios from "axios";
import router from "@/router";
import moment from "moment";

export default {
	computed: {
	
	},
	components:{
		VueJsonToCsv
	},
	name: "Customers" ,
	data: () => ({
		dataURL: "https://eakinspress.com/data/data/eakinsAdmin.cfc?",
		search: "",
		detailMode:false,
		customerArray:[],
		customerObject:{},
		startDateString:'',
		printDate:'',
		headers: [
			{
				text: "Name",
				value: "NAME",
				sortable: true
			},
			{ text: "Email", value: "EMAIL", sortable: true },
			{ text: "Order Count", value: "ORDERCOUNT", sortable: true },
			{ text: "Total Value ($)", value: "ORDERSAMOUNT", sortable: true },
			{ text: "Last Date", value: "LASTDATE", sortable: true },
		],
	}),
	methods:{
		addNewCustomer() {
			router.push({ name: "AddNewCustomer" });
		},
		getCustomers(){
			let vm=this;
			axios.get(vm.dataURL + 'method=getGeneralCustomers')
					.then(function (result){
						vm.customerArray = result.data.results;
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
		this.getCustomers();
	}
}
</script>

<style scoped>

</style>
