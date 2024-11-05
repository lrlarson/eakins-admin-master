<template>
	<v-container>
		<v-layout row wrap align-center>
			<v-flex>
				<v-card>
					<v-card-title class="justify-center">
						Home Page Settings
					</v-card-title>
				</v-card>
			</v-flex>
		</v-layout>
		<v-layout row wrap>
			<v-col md6 sm12>
				Available Heroes
			</v-col>
		</v-layout>
		<v-layout row wrap>
			<v-col md4 style="margin-left: 10px;">
				<v-simple-table>
					<template v-slot:default>
						<tbody>
						<tr>
							<td><em>Available Heroes</em></td>
						</tr>
						<tr
								v-for="item in availableHeroes"
								:key="item.ID"
								@click="handleClick(item.ID,item.TITLE)"
						>
							<td>{{ item.TITLE }}</td>
						
						</tr>
						</tbody>
					</template>
				</v-simple-table>
			</v-col>
			<v-col md4 style="margin-left: 10px;">
				<v-simple-table>
					<template v-slot:default>
						<tbody>
						<tr>
							<td><em>Assigned Heroes</em></td>
						</tr>
						<tr
								v-for="item in postedHeroes"
								:key="item.ID"
								@click="handleClick2(item.ID,item.TITLE, item.POSITION)"
						>
							<td>{{ item.POSITION }}</td>
							<td>{{ item.TITLE }}</td>
						
						</tr>
						</tbody>
					</template>
				</v-simple-table>
			</v-col>
		</v-layout>
		<v-row v-if="availableEdit">
			<v-col md4 sm12>
				<v-text-field v-model="heroObject.title" label="Title"></v-text-field>
			</v-col>
		<v-col md1 sm12>
			<v-text-field v-model="heroObject.position" label="Position"></v-text-field>
		</v-col>
			<v-col md1 sm12>
				<v-btn color="blue" @click="addToHeroes">Add to Home Page Display</v-btn>
			</v-col>
		</v-row>
		<v-row v-if="postedEdit">
			<v-col md4 sm12>
				<v-text-field v-model="heroObject.title" label="Title">:</v-text-field>
			</v-col>
			<v-col md1 sm12>
				<v-text-field v-model="heroObject.position" label="Position">:</v-text-field>
			</v-col>
			<v-col md1 sm12>
				<v-btn color="red" @click="deleteFromHeroes">Remove from Home Page Display</v-btn>
			</v-col>
		</v-row>
	</v-container>
</template>

<script>
import axios from "axios"

export default {
	name: "FrontPageControl",
	data: () => ({
		dataURL: "https://eakinspress.com/data/data/eakinsAdmin.cfc?",
		availableEdit: false,
		postedEdit: false,
		availableHeroes:[],
		postedHeroes:[],
		heroArray:[],
		heroObject:{
			id: '',
			position:'',
			title:''
		},
		headers: [
			{
				text: "Title",
				value: "TITLE",
				sortable: true
			},
			
			{ text: "File", value: "FILENAME", sortable: true },
		
		],
		headers2: [
			{
				text: "Position",
				value: "POSITION",
				sortable: true
			},
			
			{ text: "Title", value: "TITLE", sortable: true },
		
		]
	}),
	methods: {
		
		getAvailableHeroes(){
			let vm = this;
			axios.get(vm.dataURL + 'method=getAvailableHomePageFeatures')
			.then(function (response){
				vm.availableHeroes = response.data.results;
			})
			} ,
		getPostedHeroes(){
			let vm = this;
			axios.get(vm.dataURL + 'method=getHeroImages')
					.then(function(response){
					vm.postedHeroes = response.data.results;
				})
		},
		handleClick(id,title){
			this.availableEdit = true;
			this.postedEdit = false;
			this.heroObject.id = id;
			this.heroObject.title ='';
			this.heroObject.title = title;
			this.heroObject.position = 0;
		},
		handleClick2(id,title,position){
			this.availableEdit = false;
			this.postedEdit = true;
			this.heroObject.id = id;
			this.heroObject.title = title;
			this.heroObject.position = position;
		},
		deleteFromHeroes(){
			let vm = this;
			axios.get(vm.dataURL + 'method=deleteFromHeroes&photoID=' + vm.heroObject.id)
			.then(function(){
				vm.getAvailableHeroes();
				vm.getPostedHeroes();
				vm.postedEdit = false;
				vm.availableEdit = false;
			})
		},
		addToHeroes(){
			let vm = this;
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				data: {
					method: "insertHeroImage",
					heroObject: JSON.stringify(vm.heroObject)
				},
				success: function() {
					vm.getAvailableHeroes();
					vm.getPostedHeroes();
					vm.postedEdit = false;
					vm.availableEdit = false;
					
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
	mounted(){
		this.getAvailableHeroes();
		this.getPostedHeroes();
		
	}
}
</script>

<style scoped>

</style>
