<template>
<v-container>
	<v-layout row wrap align-center>
		<v-flex v-if="editMode">
			<v-card>
				<v-card-title class="justify-center">
					{{ danceIndexObject.ISSUETITLE }} -- ID: {{ danceIndexObject.ID }}
				</v-card-title>
			</v-card>
		</v-flex>
	</v-layout>
	<v-row v-if="!addMode">
		<v-col md3 sm12>
			<v-btn color="green" @click="clearDanceIndexObject">Add New Issue</v-btn>
		</v-col>
	</v-row>
	<v-row>
		<v-col md5 sm12>
			<v-text-field v-model="danceIndexObject.ISSUETITLE" label="Title"></v-text-field>
		</v-col>
		<v-col md1 sm12>
			<v-text-field
					v-model="danceIndexObject.YEAR"
					label="Year"
			></v-text-field>
		</v-col>
		<v-col md1 sm12>
			<v-text-field
					v-model="danceIndexObject.VOLUME"
					label="Volume"
			></v-text-field>
		</v-col>
		<v-col md1 sm12>
			<v-text-field
					v-model="danceIndexObject.NUMBER"
					label="Number"
			></v-text-field>
		</v-col>
		<v-col md1 sm12>
			<v-checkbox v-model="danceIndexObject.FEATUREDISSUE" label="Featured Issue" ></v-checkbox>
		</v-col>
	</v-row>
	<v-row>
		<v-col md2 sm12 style="max-width: 40%">
			<v-text-field disabled
					label="Author"
			></v-text-field>
			<ckeditor
					:editor="editor"
					v-model="danceIndexObject.AUTHORSTRING"
					:config="editorConfig"
					label="Author"
			></ckeditor>
		</v-col>
		<v-col md3 sm12>
			<v-text-field
					v-model="danceIndexObject.ARCHIVEID"
					label="ArchiveID"
			></v-text-field>
		</v-col>
		<v-col md1 sm12>
			<v-text-field
					v-model="danceIndexObject.PRICE"
					label="Price" prefix="$"
			></v-text-field>
		</v-col>
		<v-col md1 sm12>
			<v-checkbox v-model="danceIndexObject.FORSALE" label="For Sale"></v-checkbox>
		</v-col>
		<v-col md1 sm12>
			<v-text-field disabled
					v-model="danceIndexObject.COVERIMAGE"
					label="Cover Image Filename"
			></v-text-field>
		</v-col>
	</v-row>
	<v-row>
		<v-col md3 style="margin-left: 2px; max-width:45%;" >
<!--			<v-text-field disabled label="Colophon"-->
<!--			></v-text-field>-->
<!--			<ckeditor-->
<!--					:editor="editor"-->
<!--					v-model="danceIndexObject.ISSUETECHDESCRIPTION"-->
<!--					:config="editorConfig"-->
<!--					label="Author"-->
<!--			></ckeditor>-->
			<v-textarea label="Colophon" v-model="danceIndexObject.ISSUETECHDESCRIPTION" rows="9"></v-textarea>
		</v-col>
		<v-col md3 style="margin-left: 2px; max-width:45%;" >
			<v-checkbox v-model="danceIndexObject.DISPLAY" label="Display --- Sets whether this issues appears on Website"></v-checkbox>
		</v-col>
	</v-row>
	
	<v-row>
		<v-col md3 style="margin-left: 2px; max-width:45%;" >
			<div class="DashboardContainer" id="uppyHolder">Select Cover Image</div>
		</v-col>
		<v-col md3 sm12 STYLE="max-width:45%">
			
			<v-img v-if="danceIndexObject.COVERIMAGE" :src="'https://eakinspress.com/danceindex/images/forSale/' + danceIndexObject.COVERIMAGE" style="max-width: 50%"></v-img>
		</v-col>
	</v-row>
	<v-row>
		<v-col md6 sm12 style>
			<v-text-field disabled
										label="Short Description"
			></v-text-field>
			<ckeditor
					:editor="editor"
					v-model="danceIndexObject.SHORTDESCRIPTION"
					:config="editorConfig"
					label="Author"
			></ckeditor>
		</v-col>
	</v-row>
	<v-row>
		<v-col md6 sm12 style>
			<v-text-field disabled
										label="Long Description"
			></v-text-field>
			<ckeditor
					:editor="editor"
					v-model="danceIndexObject.LONGDESCRIPTION"
					:config="editorConfig"
					label="Author"
			></ckeditor>
		</v-col>
	</v-row>
	<v-row>
		<v-col md3 sm12 style="margin-left: 10px;max-width: 20%">
			<v-text-field label="Weight in Grams" v-model="danceIndexObject.GRAMS"></v-text-field>
		</v-col>
	</v-row>
	<v-row>
		<v-col md3 style="margin-left: 2px; max-width:45%;" >
			<div class="DashboardContainer" id="uppyHolder2">Select Feature Image 1</div>
		</v-col>
		<v-col md3 sm12 STYLE="max-width:45%">
			
			<v-img v-if="danceIndexObject.FEATUREDISSUEIMAGE" :src="'https://eakinspress.com/images/dance_index/' + danceIndexObject.FEATUREDISSUEIMAGE" style="max-width: 80%"></v-img>
		</v-col>
	</v-row>
	<v-row>
		<v-col md3 style="margin-left: 2px; max-width:45%;" >
			<div class="DashboardContainer" id="uppyHolder3">Select Feature Image 2</div>
		</v-col>
		<v-col md3 sm12 STYLE="max-width:45%">
			
			<v-img v-if="danceIndexObject.FEATUREDISSUEIMAGE2" :src="'https://eakinspress.com/images/dance_index/' + danceIndexObject.FEATUREDISSUEIMAGE2" style="max-width: 80%"></v-img>
		</v-col>
	</v-row>
	<v-row>
		<v-col md3 style="margin-left: 2px; max-width:45%;" >
			<div class="DashboardContainer" id="uppyHolder4"> Select Downlodable PDF</div>
		</v-col>
		<v-col md3 sm12 STYLE="max-width:45%">
			<v-text-field disabled v-model="danceIndexObject.PDFFORSALE" label="filename"></v-text-field>
		</v-col>
	</v-row>
	<v-row>
		<v-col md3>
			<v-btn style="margin-left:10px;margin-bottom: 10px;" v-if="editMode" color="green" @click="updateIssue" >Save Edits</v-btn>
			<v-btn style="margin-left:10px;margin-bottom: 10px;" v-if="addMode" color="green" @click="saveNewIssue" >Save New Issue</v-btn>
		</v-col>
	</v-row>
	<v-card>
		<v-tabs>
			<v-tab v-if="editMode" style="font-size: large" ripple key="1" @click="saleInfoClick" >Articles</v-tab>
		
			<v-tab-item key="1" >
				<v-btn color="blue" style="margin-left: 10px; margin-top:10px;" @click="clearArticleObject">Add Article</v-btn>
				<v-row>
					<v-col md12>
				<v-simple-table>
					<template v-slot:default>
						<tbody>
						<tr>
							<td>Article</td>
							<td>Author</td>
							<td>Editor</td>
						</tr>
						<tr
								v-for="item in articlesArray"
								:key="item.ID"
								@click="getArticleDetails(item.ID)"
						>
							<td>{{ item.ARTICLE }}</td>
							<td>{{ item.AUTHOR }}</td>
							<td>{{ item.EDITOR }}</td>
						
						</tr>
						</tbody>
					</template>
				</v-simple-table>
					</v-col>
				</v-row>
				<v-row v-if="articleEdit || articleAdd" style="background-color:aliceblue">
					<v-col md3 sm12 style="margin-left: 10px">
						<v-text-field v-model="articleObject.ARTICLE" label="Article"></v-text-field>
					</v-col>
					<v-col md3 sm12 style="margin-left: 10px">
					<v-text-field v-model="articleObject.AUTHOR" label="Author"></v-text-field>
					</v-col>
					<v-col md3 sm12 style="margin-left: 10px">
						<v-text-field v-model="articleObject.EDITOR" label="Editor"></v-text-field>
					</v-col>
				</v-row>
				<v-row>
					<v-col md3 sm12 style="margin-left: 10px">
						<v-btn v-if="articleEdit" color="blue" @click="updateArticle">Save Article Edits</v-btn>
						<v-btn v-if="articleAdd" color="blue" @click="insertNewArticle">Save New Article </v-btn>
					</v-col>
				</v-row>
			</v-tab-item>
			
		</v-tabs>
	</v-card>
	<v-snackbar v-model="snackbar">
		{{ text }}
		<template v-slot:action="{ attrs }">
			<v-btn
					color="pink"
					text
					v-bind="attrs"
					@click="snackbar = false"
					:timeout="timeout"
			>
			
			</v-btn>
		</template>
	</v-snackbar>
</v-container>

</template>

<script>
import axios from "axios";
import ClassicEditor from "@ckeditor/ckeditor5-build-classic";
import Uppy from '@uppy/core'
import Dashboard from '@uppy/dashboard'
const XHRUpload = require("@uppy/xhr-upload");
import router from "../router";
require("@uppy/core/dist/style.css");
require("@uppy/dashboard/dist/style.css");
export default {
	name: "DanceIndexDetail",
	data: () => ({
		dataURL: "https://eakinspress.com/data/data/eakinsAdmin.cfc?",
		editMode: false,
		addMode: false,
		danceIndexIssueArray:[],
		danceIndexObject:{},
		issueID:null,
		timeout: 1000,
		editor: ClassicEditor,
		editorData: "",
		editorConfig: {},
		articlesArray:[],
		articleArray:[],
		articleObject:{} ,
		articleEdit:false,
		articleAdd:false,
		snackbar:false,
		text:'Saved',
		newID:0
		
	}),
	methods: {
		insertNewArticle(){
			let vm = this;
			vm.articleObject.issueID = vm.issueID;
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				data: {
					method: "createArticle",
					article: JSON.stringify(vm.articleObject)
				},
				success: function() {
					vm.articleEdit = false;
					vm.snackbar = true;
					vm.getArticles(vm.danceIndexObject.ID )
					vm.articleAdd = false;
					
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
		updateArticle(){
			let vm = this;
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				data: {
					method: "updateArticle",
					article: JSON.stringify(vm.articleObject)
				},
				success: function() {
					vm.snackbar = true;
					this.getIssueDetails(vm.danceIndexObject.ID );
					
					
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
		
		getArticleDetails(articleID){
			let vm = this;
			vm.articleEdit = true;
			vm.articleAdd = false;
			axios.get(vm.dataURL + 'method=getArticleDetails&id=' + articleID)
			.then(function (response){
				vm.articleArray = response.data.results;
				vm.articleObject = vm.articleArray[0];
			})
		},
		saveNewIssue(){
			let vm = this;
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				data: {
					method: "insertNewIssue",
					newIssue: JSON.stringify(vm.danceIndexObject)
				},
				success: function() {
					vm.getNewID();
					vm.snackbar = true;
					vm.addMode = false;
					this.editMode = true;
					router.push({name:'DanceIndex'});
					
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
		getNewID() {
			let vm = this;
			axios.get(vm.dataURL + "method=getNewID").then(function(response) {
				vm.newID = response.data.DATA[0];
			});
			return vm.newID;
		},
		updateIssue(){
			let vm = this;
			vm.danceIndexObject.ID = vm.issueID;
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				data: {
					method: "updateIssue",
					newIssue: JSON.stringify(vm.danceIndexObject)
				},
				success: function() {
					vm.snackbar = true;
					vm.getIssueDetails(vm.danceIndexObject.ID );
					
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
		
		getArticles(issueID){
			let vm = this;
			axios.get(vm.dataURL + 'method=getArticlesForIssue&issueID=' + issueID)
			.then(function (response){
				vm.articlesArray = response.data.results;
			})
		},
		
		getIssueDetails(issueID){
		let vm = this;
		axios.get(vm.dataURL + 'method=getSpecificIssue&issueID=' + issueID)
			.then(function(response){
				vm.danceIndexIssueArray = response.data.results;
				vm.danceIndexObject = vm.danceIndexIssueArray[0];
			})
		},
		clearArticleObject(){
			this.articleObject.ARTICLE = '';
			this.articleObject.AUTHOR = '';
			this.articleObject.EDITOR = '';
			this.articleEdit = false;
			this.articleAdd = true;
		},
		clearDanceIndexObject(){
			this.setAll(this.danceIndexObject,'');
			this.articlesArray.length = null;
			this.editMode = false;
			this.addMode = true;
			
		},
	setAll(obj, val) {
		Object.keys(obj).forEach(function(index) {
			obj[index] = val
			});
		},
		saleInfoClick(){
			alert('saleInfoClick click')
		},
		initUppy() {
			const uppyLarge = new Uppy({ debug: true  })
					
					.use(Dashboard, {
						trigger: ".UppyModalOpenerBtn",
						inline: true,
						target: "#uppyHolder",
						height: 300,
						id:'uppy',
						width: 250
					})
					.use(XHRUpload, {
						endpoint: '/danceindex/images/forSale/uploadDanceIndexCover.cfm',
						formData: true,
						fieldName: "fileData",
						headers: {
							encType:'multipart/form-data',
							contentType: 'multipart/form-data'
						}
					});
			
			uppyLarge.on("complete", result => {
				// eslint-disable-next-line
				console.log(
						"Upload complete! We’ve uploaded these files:",
						result.successful
				);
				this.danceIndexObject.COVERIMAGE = result.successful[0].name;
				
			});
		},
		initUppy2() {
			const uppyLarge = new Uppy({ debug: true  })
					
					.use(Dashboard, {
						trigger: ".UppyModalOpenerBtn",
						inline: true,
						target: "#uppyHolder2",
						height: 300,
						id:'uppy2',
						width: 250
					})
					.use(XHRUpload, {
						endpoint: '/images/dance_index/uploadDanceIndexImages.cfm',
						formData: true,
						fieldName: "fileData",
						headers: {
							encType:'multipart/form-data',
							contentType: 'multipart/form-data'
						}
					});
			
			uppyLarge.on("complete", result => {
				// eslint-disable-next-line
				console.log(
						"Upload complete! We’ve uploaded these files:",
						result.successful
				);
				this.danceIndexObject.FEAUTUREDISSUEIMAGE = result.successful[0].name;
				
			});
			
		},
		initUppy3() {
			const uppyLarge = new Uppy({ debug: true  })
					
					.use(Dashboard, {
						trigger: ".UppyModalOpenerBtn",
						inline: true,
						target: "#uppyHolder3",
						height: 300,
						id:'uppy3',
						width: 250
					})
					.use(XHRUpload, {
						endpoint: '/images/dance_index/uploadDanceIndexImages.cfm',
						formData: true,
						fieldName: "fileData",
						headers: {
							encType:'multipart/form-data',
							contentType: 'multipart/form-data'
						}
					});
			
			uppyLarge.on("complete", result => {
				// eslint-disable-next-line
				console.log(
						"Upload complete! We’ve uploaded these files:",
						result.successful
				);
				this.danceIndexObject.FEAUTUREDISSUEIMAGE2 = result.successful[0].name;
				
			});
			
		},
		initUppy4() {
			const uppyLarge = new Uppy({ debug: true  })
					
					.use(Dashboard, {
						trigger: ".UppyModalOpenerBtn",
						inline: true,
						target: "#uppyHolder4",
						height: 300,
						id:'uppy4',
						width: 250
					})
					.use(XHRUpload, {
						endpoint: '/danceindex/downloads/uploadPDF.cfm',
						formData: true,
						fieldName: "fileData",
						headers: {
							encType:'multipart/form-data',
							contentType: 'multipart/form-data'
						}
					});
			
			uppyLarge.on("complete", result => {
				// eslint-disable-next-line
				console.log(
						"Upload complete! We’ve uploaded these files:",
						result.successful
				);
				this.danceIndexObject.PDFFORSALE = result.successful[0].name;
				
			});
			
		},
	},
	mounted(){
		this.issueID = this.$route.params.id;
		if(this.issueID>0){
			this.editMode = true;
			this.addMode = false;
			this.getIssueDetails(this.issueID );
			this.getArticles(this.issueID);
			this.initUppy();
			this.initUppy2();
			this.initUppy3();
			this.initUppy4();
		} else {
			this.editMode = false;
			this.addMode = true;
			this.initUppy();
			this.initUppy2();
			this.initUppy3();
			this.initUppy4();
		}
		
		
	}
}
</script>

<style scoped>

</style>
