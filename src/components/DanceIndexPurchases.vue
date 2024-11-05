<template>
<v-container>
	<v-layout row wrap align-center>
		<v-flex>
			<v-card>
				<v-card-title class="justify-center">
					Dance Index Purchases
				</v-card-title>
			</v-card>
		</v-flex>
	</v-layout>
	<v-layout row wrap>
		<v-container grid-list-md>
			<v-data-table
					:headers="headers"
					:items="purchaseArray"
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
				<template v-slot:item.SUBSCRIPTION="{ item }">
					<v-simple-checkbox
							v-model="item.SUBSCRIPTION"
							disabled
					></v-simple-checkbox>
				</template>
			</v-data-table>
		</v-container>
	</v-layout>
	<v-row v-if="detailMode" style="background-color: aliceblue" id="editArea">
		<v-col md3 sm12>
			<v-text-field v-model="customerObject.SHIPPINGADDRESSNAME" label="Name"></v-text-field>
		</v-col>
		<v-col md3 sm12>
			<v-text-field v-model="customerObject.CUSTOMEREMAIL" label="Email"></v-text-field>
		</v-col>
		<v-col md3 sm12>
			<v-text-field v-model="customerObject.NUMBEROFISSUES" label="# of Issues"></v-text-field>
		</v-col>
	</v-row>
	<v-row v-if="detailMode" style="background-color: aliceblue">
		<v-col md3 sm12>
			<v-text-field v-model="customerObject.SHIPPINGADDRESSADDRESS1" label="Address1"></v-text-field>
		</v-col>
		<v-col md3 sm12>
			<v-text-field v-model="customerObject.SHIPPINGADDRESSADDRESS2" label="Address2"></v-text-field>
		</v-col>
		<v-col md2 sm12>
			<v-text-field v-model="customerObject.SHIPPINGADDRESSCITY" label="City"></v-text-field>
		</v-col>
		<v-col md1 sm12>
			<v-text-field v-model="customerObject.SHIPPINGADDRESSSTATE" label="State"></v-text-field>
		</v-col>
		<v-col md1 sm12>
			<v-text-field v-model="customerObject.SHIPPINGADDRESSPOSTALCODE" label="Zip"></v-text-field>
		</v-col>
		
		<v-col md3 sm12>
			<v-text-field v-model="customerObject.NUMBEROFISSUES" label="# of Issues"></v-text-field>
		</v-col>
	</v-row>
	<v-row v-if="detailMode" style="background-color: aliceblue">
		<v-col md3 sm12>
			<v-text-field v-model="customerObject.SHIPPINGADDRESSCOMPANYNAME" label="Company"></v-text-field>
		</v-col>
		<v-col md1 sm12>
			<v-text-field v-model="customerObject.SHIPPINGADDRESSCOUNTRY" label="Country"></v-text-field>
		</v-col>
		<v-col md3 sm12>
			<v-text-field v-model="customerObject.TRANSDATE" label="Date"></v-text-field>
		</v-col>
	</v-row>
	
</v-container>
</template>

<script>
import axios from "axios";
export default {
	name: "DanceIndexPurchases",
	data: () => ({
		dataURL: "https://eakinspress.com/data/data/eakinsAdmin.cfc?",
		purchaseArray:[],
		search: "",
		detailMode:false,
		customerArray:[],
		customerObject:{},
		headers: [
			{
				text: "Sale Date",
				value: "TRANSDATE",
				sortable: true
			},
			
			{ text: "# of Issues", value: "NUMBEROFISSUES", sortable: true },
			{ text: "Name", value: "SHIPPINGADDRESSNAME", sortable: true },
			{ text: "Email", value: "CUSTOMEREMAIL", sortable: true },
			{ text: "Subscription", value: "SUBSCRIPTION", sortable: true },
		],
	}),
	methods: {
		handleClick(value){
			let vm = this;
			axios.get(vm.dataURL + 'method=getDIPurchaseDetails&id=' + value.ID)
			.then(function (response){
				vm.customerArray = response.data.results;
				vm.customerObject = vm.customerArray[0];
				vm.detailMode = true;
				
				vm.$vuetify.goTo(vm.pageHeight);
			})
		},
		getPurchases(){
			let vm = this;
			axios.get(vm.dataURL + 'method=getDIPurchases')
			.then(function (response){
				vm.purchaseArray = response.data.results;
				vm.purchaseArray.forEach(function(sub){
					if (sub.NUMBEROFISSUES >1){
						sub.SUBSCRIPTION = true;
					}else{
						sub.SUBSCRIPTION = false;
					}
				})
			})
		} ,
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
	mounted(){
		this.getPurchases();
	},
	computed: {
		pageHeight () {
			return document.body.scrollHeight
		}
	}
}
</script>

<style scoped>
.v-application a {
	color: #000000;
}
</style>
