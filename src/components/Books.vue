<template>
	<v-container>
		<v-layout row wrap align-center>
			<v-flex>
				<v-card>
					<v-card-title class="justify-center">
						BOOKS --- Click to Edit
					</v-card-title>
					<v-card-text class="justify-center">
						<v-btn @click="addWork(0)">
							Add New Book
						</v-btn>
					</v-card-text>
				</v-card>
			</v-flex>
		</v-layout>
		<v-layout row wrap>
			<v-container grid-list-md>
				<v-data-table
						:headers="headers"
						:items="books"
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
	name: "Books",
	data: () => ({
		dataURL: "https://eakinspress.com/data/data/eakinsAdmin.cfc?",
		editMode: false,
		addMode: false,
		books: [],
		search: "",
		headers: [
			{
				text: "Title",
				value: "TITLE",
				sortable: true
			},
			
			{ text: "Year", value: "YEAR", sortable: true },
			{ text: "ID", value: "ID", sortable: true },
		]
	}),
	methods:{
		getBooks(){
			let vm = this;
			axios.get(vm.dataURL + 'method=getAllBooks')
			.then(function (response){
				vm.books = response.data.results;
			})
		},
		handleClick(value){
			router.push({ name: "Book-Detail", params: { id: value.ID } });
		},
		addWork(value){
			router.push({ name: "Book-Detail", params: { id: value } });
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
		this.getBooks();
	}
}
</script>

<style scoped>

</style>
