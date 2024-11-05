<template>
<v-container>
	<v-layout row wrap align-center>
		<v-flex>
			<v-card>
				<v-card-title class="justify-center">
					Dance Index Issues -- Click to Edit
				</v-card-title>
				<v-card-text class="justify-center">
					<v-row>
						<v-col>
					<v-btn @click="addNewIssue(0)">
						Add New New Issue
					</v-btn>
						</v-col>
						
					</v-row>
				</v-card-text>
			</v-card>
		</v-flex>
	</v-layout>
	<v-layout row wrap>
		<v-container grid-list-md>
			<v-data-table
					:headers="headers"
					:items="danceIndexIssuesArray"
					:items-per-page="1000"
					class="elevation-1"
					@click:row="handleIssueClick"
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
import router from "@/router";
//import ClassicEditor from "@ckeditor/ckeditor5-build-classic";
//import Uppy from '@uppy/core'
//import Dashboard from '@uppy/dashboard'
//const XHRUpload = require("@uppy/xhr-upload");
require("@uppy/core/dist/style.css");
require("@uppy/dashboard/dist/style.css");
export default {
	name: "DanceIndex",
	data: () => ({
		dataURL: "https://eakinspress.com/data/data/eakinsAdmin.cfc?",
		editMode: false,
		addMode: false,
		danceIndexIssuesArray:[],
		danceIndexObject:{},
		search: "",
		headers: [
			{
				text: "Issue Title",
				value: "ISSUETITLE",
				sortable: true
			},
			
			{ text: "Year", value: "YEAR", sortable: true },
			{ text: "Volume", value: "VOLUME", sortable: true },
			{ text: "For Sale", value: "FORSALE", sortable: true },
		]
		
	}),
	methods: {
		handleIssueClick(value){
			alert
			router.push({ name: "DanceIndexDetail", params: { id: value.ID } });
		},
		
		getDanceIndexIssues(){
			let vm = this;
			axios.get(vm.dataURL + 'method=getAllDanceIndexIssues')
			.then(function (response){
				vm.danceIndexIssuesArray = response.data.results;
			})
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
		addNewIssue(value){
			router.push({ name: "DanceIndexDetail", params: { id: value } });
		}
	},
	mounted() {
		this.getDanceIndexIssues();
	}
}
</script>

<style scoped>

</style>
