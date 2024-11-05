<template>
	<v-container>
		<v-row>
			<v-col cols="12">
				<v-card>
					<v-card-title>
						<h1>Add New Customer</h1>
					</v-card-title>
					<v-card-text>
						<v-form>
							<v-text-field
									label="Name"
									v-model="customerObject.name"
							></v-text-field>
							<v-text-field
									label="Email"
									v-model="customerObject.email"
							></v-text-field>
							<v-text-field
									label="Phone"
									v-model="customerObject.phone"
							></v-text-field>
							<v-text-field
									label="Address 1"
									v-model="customerObject.address_1"
							></v-text-field>
							<v-text-field
									label="Address 2"
									v-model="customerObject.address_2"
							></v-text-field>
							<v-text-field
									label="City"
									v-model="customerObject.city"
							></v-text-field>
							<v-text-field
									label="State"
									v-model="customerObject.state"
							></v-text-field>
							<v-text-field
									label="Zip"
									v-model="customerObject.zip"
							></v-text-field>
							<v-text-field
									label="Country"
									v-model="customerObject.country"
							></v-text-field>
							<v-text-field
									label="Notes"
									v-model="customerObject.comments"
							></v-text-field>
							<v-btn
									color="primary"
									@click="addNewCustomer"
							>Add New Customer</v-btn>
						</v-form>
					</v-card-text>
				</v-card>
			</v-col>
		</v-row>
	</v-container>
</template>

<script>
// import axios from "axios";
export default {
	name: "AddNewCustomer",
	data() {
		return {
			customerObject: {},
			dataURL: "https://eakinspress.com/data/data/eakinsAdmin.cfc?",
		};
	},
	methods: {
		addNewCustomer() {
			let vm = this;
			vm.customerObject.snipcart_Id = vm.createUUID();
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				
				data: {
					method: "addNewCustomer",
					customerObject: JSON.stringify(vm.customerObject),
				},
				success: function() {
					// alert("Customer Added");
					vm.$router.push({ name: "Customers" });
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
		cleanCustomerObject() {
			let vm = this;
			vm.customerObject.name = "";
			vm.customerObject.email = "";
			vm.customerObject.phone = "";
			vm.customerObject.address_1 = "";
			vm.customerObject.address_2 = "";
			vm.customerObject.city = "";
			vm.customerObject.state = "";
			vm.customerObject.zip = "";
			vm.customerObject.country = "";
			vm.customerObject.comments = "";
			vm.customerObject.notes = "";
		},
	},
	mounted() {
		this.cleanCustomerObject();
	}
}
</script>

<style scoped>

</style>
