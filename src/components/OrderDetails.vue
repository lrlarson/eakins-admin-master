<template>
	<v-container>
		<v-layout row wrap align-center>
			<v-flex>
				<v-card>
					<v-card-title class="justify-center">
						Order Details
						
					</v-card-title>
					<div style="text-align: center"><em>{{orderDetailArray[0].NAME}}</em></div>
					<div style="text-align: center"><em>{{orderDetailArray[0].DATE}}</em></div>
					<div style="text-align: center"><em>Total Amount ${{orderDetailArray[0].TOTALAMOUNT}}</em></div>
					<div style="text-align: center"><em>Invoice Number {{orderDetailArray[0].INVOICENUMBER}}</em></div>
				</v-card>
			</v-flex>
		</v-layout>
		
		<v-layout row wrap>
			<v-container grid-list-md>
				
				<v-data-table
						:headers="headers"
						:items="orderDetailArray"
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
		<v-layout row>
			<v-btn @click="returnToOrderSummary">Return to Order Summary</v-btn>
		</v-layout>
	</v-container>
</template>

<script>
import axios from "axios";
import router from "@/router";
export default {
	name: "OrderDetails" ,
	data: () => ({
		dataURL: "https://eakinspress.com/data/data/eakinsAdmin.cfc?",
		search: "",
		detailMode:false,
		orderDetailArray:[],
		orderObject:{},
		trans_ID:'',
		headers: [
			{
				text: "Item",
				value: "ITEMNAME",
				sortable: true
			},
			{ text: "Quantity", value: "ITEM_QUANTITY", sortable: true },
			{ text: "Item Amount", value: "PRICE", sortable: true },
		],
	}),
	methods:{
		
		getOrderDetails(){
			let vm=this;
			axios.get(vm.dataURL + 'method=getOrderDetails&trans_ID=' + vm.trans_ID)
					.then(function (result){
						vm.orderDetailArray = result.data.results;
					})
			
		},
		handleClick(){
		
		},
		returnToOrderSummary(){
			router.push({ name: "CustomerOrders", params: { snipcart_ID: this.orderDetailArray[0].SNIPCART_ID } });
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
		this.trans_ID= this.$route.params.trans_ID;
		this.getOrderDetails();
	},
	created() {
	
	}
}
</script>

<style scoped>

</style>
