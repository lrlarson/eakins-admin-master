<template>
	<v-container>
		<v-layout row wrap align-center>
			<v-flex>
				<v-card>
					<v-card-title class="justify-center">
						General Customer Purchases Summary
						
					</v-card-title>
					<div style="text-align: center">{{customerDetailsArray[0].NAME}}</div>
					<div style="text-align: center">{{customerDetailsArray[0].ADDRESS_1}} {{customerDetailsArray[0].ADDRESS_2}}</div>
					<div style="text-align: center">{{customerDetailsArray[0].CITY}}, {{customerDetailsArray[0].STATE}} {{customerDetailsArray[0].ZIP}} {{customerDetailsArray[0].COUNTRY}}</div>
					<div style="text-align: center">{{customerDetailsArray[0].EMAIL}}</div>
					<div style="text-align: center;margin-top: 5px;"><v-btn color="blue" @click="customerEdit">Edit/Read-Write Comments</v-btn> </div>
					<div style="text-align: center;margin-top: 5px;padding-bottom:  5px;"><v-btn color="green" @click="intializePOSMode">Add POS Purchase</v-btn> </div>
				</v-card>
			</v-flex>
		</v-layout>
		
		<v-layout row wrap>
			<v-container grid-list-md>
				Click for Details
				<v-data-table
						:headers="headers"
						:items="ordersArray"
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
		<v-layout style="margin-top: 15px;" v-if="editMode">
			
				<v-col md-8>
					<v-row>
					<em>Name:  </em><v-text-field v-model="ordersArray[0].NAME" hint="Name"></v-text-field>
					</v-row>
					<v-row>
						<em>Email:  </em><v-text-field v-model="ordersArray[0].EMAIL" hint="Email"></v-text-field>
					</v-row>
					<v-row>
						Address 1<v-text-field v-model="ordersArray[0].ADDRESS_1" hint="Address 1"></v-text-field>
					</v-row>
					<v-row>
						Address 2<v-text-field v-model="ordersArray[0].ADDRESS_2" hint="Address 2"></v-text-field>
					</v-row>
					<v-row>
						<em>City:   </em><v-text-field v-model="ordersArray[0].CITY" hint="City"></v-text-field>
					</v-row>
					<v-row>
						<em>State:  </em><v-text-field style="max-width: 35%" v-model="ordersArray[0].STATE" hint="State"></v-text-field>
						<em>Zip:   </em><v-text-field style="max-width: 35%" v-model="ordersArray[0].ZIP" hint="State"></v-text-field>
					</v-row>
					<v-row>
						<em>Country:</em><v-text-field style="max-width: 35%"  v-model="ordersArray[0].COUNTRY" hint="State"></v-text-field>
						<em>Newsletter:</em> <v-checkbox v-model="customerObject.NEWSLETTER"></v-checkbox>
					</v-row>
					<v-row>
						<em>Comments:</em><v-textarea v-model="customerObject.COMMENTS"></v-textarea>
					</v-row>
				</v-col>
			<v-col md4>
					<v-btn color="green" @click="updateCustomer">Save Edits</v-btn>
			</v-col>
		</v-layout>
		<v-layout v-if="POSMode" style="margin-top: 10px;">
			<v-row>
				<v-col md4>
					<v-select v-model="orderObject.PRODUCT_ID" :items="productsArray" item-text="NAME" item-value="PRODUCT_ID" label="Product" return-object></v-select>
				</v-col>
				<v-col md2>
					<v-btn color="blue" @click="addProductToOrder">Add Product</v-btn>
				</v-col>
				<v-col md4>
					<v-simple-table>
						<template v-slot:default>
							<thead>
							<tr>
								<th class="text-left">
									Product
								</th>
								<th class="text-left">
									Price
								</th>
							</tr>
							</thead>
							<tbody>
							<tr
									v-for="item in orderArray"
									:key="item.ITEMS__ITEMS__ID"
							>
								<td>{{ item.NAME }}</td>
								<td>{{ item.PRICE }}</td>
							</tr>
							</tbody>
						</template>
					</v-simple-table>
				</v-col>
				<v-col md2>
					
					Total:{{totalPrice}} <br />
						<v-btn color="green" @click="saveNewOrder">Save Order</v-btn>
					
				</v-col>
			</v-row>
		</v-layout>
	</v-container>
</template>

<script>
import axios from "axios";
import router from "@/router";
export default {
	name: "CustomerOrders" ,
	data: () => ({
		dataURL: "https://eakinspress.com/data/data/eakinsAdmin.cfc?",
		search: "",
		detailMode:false,
		editMode:false,
		POSMode:false,
		ordersArray:[],
		orderObject:{},
		customerObject:{},
		snipcart_ID:'',
		productsArray:[],
		orderArray:[],
		totalPrice:Number(0),
		numberOfItems:0,
		trans_ID: '',
		customerDetailsArray:[],
		
		headers: [
			{
				text: "Name",
				value: "NAME",
				sortable: true
			},
			{ text: "Date", value: "DATE", sortable: true },
			{ text: "Number of Items", value: "NUMBEROFITEMS", sortable: true },
			{ text: "Total Value ($)", value: "AMOUNT", sortable: true },
		],
	}),
	methods:{
		customerEdit(){
			let vm = this;
			vm.editMode = true;
			vm.POSMode = false;
			vm.detailMode = false;
			vm.$vuetify.goTo(vm.pageHeight);
		},
		
		saveNewOrder(){
			let vm = this;
			vm.trans_ID = vm.createUUID();
			// vm.customerObject.SNIPCART_ID = vm.snipcart_ID;
			// alert(vm.customerObject.SNIPCART_ID);
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				
				data: {
					method: "saveNewOrder",
					orderArray: JSON.stringify(vm.orderArray),
					// customerObject: JSON.stringify(vm.customerObject),
					snipcart_ID: vm.snipcart_ID,
					trans_ID: vm.trans_ID,
					totalPrice: vm.totalPrice,
				},
				success: function() {
					// vm.snackbar = true;
					// vm.addMode = false;
					vm.editMode = false;
					vm.POSMode = false;
					vm.getCustomerOrders();
				},
				error: function(jqXHR, exception) {
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
		

		createUUID(){
			let dt = new Date().getTime();
			let uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
				let r = (dt + Math.random()*16)%16 | 0;
				dt = Math.floor(dt/16);
				return (c=='x' ? r :(r&0x3|0x8)).toString(16);
			});
			return uuid;
		},
		
		addProductToOrder(){
			let vm = this;
			vm.numberOfItems = vm.numberOfItems + 1;
			//add object to array
			vm.orderArray.push(vm.orderObject.PRODUCT_ID);
			//cast as number
			vm.totalPrice = vm.totalPrice + Number(vm.orderObject.PRODUCT_ID.PRICE);
		},
		
		
		intializePOSMode(){
			let vm = this;
			vm.POSMode = true;
			vm.editMode = false;
			vm.detailMode = false;
			vm.getProducts();
			vm.$vuetify.goTo(vm.pageHeight);
		},
		getProducts(){
			let vm=this;
			axios.get(vm.dataURL + 'method=getProducts')
					.then(function (results){
						vm.productsArray = results.data.results;
					})
		},
		getCustomerOrders(){
			let vm=this;
			axios.get(vm.dataURL + 'method=getOrdersForCustomer&snipcart_ID=' + vm.snipcart_ID)
					.then(function (result){
						// if(result.data.results.length == 0){
						// 	alert("No orders found for this customer.");
						// 	return;
						// }
						vm.ordersArray  = result.data.results;
						vm.customerObject = vm.ordersArray[0];
					})
		},
		getCustomerDetails(){
			let vm=this;
			axios.get(vm.dataURL + 'method=getBasicCustomerData&snipcart_ID=' + vm.snipcart_ID)
					.then(function (result){
						vm.customerDetailsArray  = result.data.results;
					})
		},
		handleClick(value){
			router.push({ name: "OrderDetails", params: { trans_ID: value.TRANS_ID } });
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
		updateCustomer(){
			let vm = this;
			vm.customerObject.SNIPCART_ID = vm.snipcart_ID;
			// alert(vm.customerObject.SNIPCART_ID);
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				
				data: {
					method: "updateCustomerAdmin",
					customerObject: JSON.stringify(vm.customerObject)
				},
				success: function() {
					// vm.snackbar = true;
					// vm.addMode = false;
					vm.editMode = false;
				},
				error: function(jqXHR, exception) {
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
		}
	},
	mounted() {
		this.snipcart_ID= this.$route.params.snipcart_ID;
		this.getCustomerDetails();
		this.getCustomerOrders();
	},
	computed: {
		pageHeight () {
			return document.body.scrollHeight
		}
	}
}
</script>

<style scoped>

</style>
