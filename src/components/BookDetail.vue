<template>
<v-container>
	<v-layout row wrap align-center>
		<v-flex v-if="editMode">
			<v-card>
				<v-card-title class="justify-center">
					{{ bookObject.TITLE }} -- ID: {{ bookObject.ID }}
				</v-card-title>
			</v-card>
		</v-flex>
	</v-layout>
	<v-row>
		<v-col md4 sm12>
			<v-text-field v-model="bookObject.TITLE" label="Title"></v-text-field>
		</v-col>
		<v-col md4 sm12>
			<v-text-field
					v-model="bookObject.SUBTITLE"
					label="SubTitle"
			></v-text-field>
		</v-col>
		<v-col md4 sm12>
			<v-text-field
					v-model="bookObject.SLUG"
					label="Slug"
					hint="book-title-lower-case-hyphen"
			></v-text-field>
		</v-col>
	</v-row>
	<v-row>
	<v-col md4 sm12>
			<v-text-field label="Description" disabled></v-text-field>
			<ckeditor
					:editor="editor"
					v-model="bookObject.LONG_DESCRIPTION"
					:config="editorConfig"
					label="Decription"
			></ckeditor>
		</v-col>
	</v-row>
  <v-row>
	<v-col md2 sm12>
		<v-text-field label="Credits" disabled></v-text-field>
		<ckeditor
				:editor="editor"
				v-model="bookObject.CREDITS"
				:config="editorConfig"
				label="Credits"
		></ckeditor>
	</v-col>
	<v-col md1 sm12>
		<v-text-field label="Year" v-model="bookObject.YEAR"></v-text-field>
	</v-col>
	
</v-row>
	<v-row>
		<v-col md2 sm12>
			<v-text-field label="Colophon" disabled></v-text-field>
			<ckeditor
					:editor="editor"
					v-model="bookObject.COLOPHON"
					:config="editorConfig"
					label="Colophon"
			></ckeditor>
		</v-col>
		<v-col md5 sm12>
			<v-text-field label="Specs" v-model="bookObject.SPECS"></v-text-field>
		</v-col>
	</v-row>
	<v-row>
		<v-col md3 v-if="addMode">
			<v-btn color="green" @click="saveNewBook">Save New Book</v-btn>
		</v-col>
		<v-col md3 v-if="editMode">
			<v-btn color="green" @click="updateBook">Save General Book Edits</v-btn>
		</v-col>
	</v-row>
	<v-card v-if="editMode">
		<br />

		<v-tabs>
			<v-tab style="font-size: large" ripple key="1" @click="bookCatsClick" >Categories</v-tab>
			<v-tab style="font-size: large" ripple key="2" @click="bookEditionsClick" >Editions</v-tab>
			<v-tab style="font-size: large" ripple key="3" @click="bookAssetsClick" >Assets</v-tab>
			<v-tab style="font-size: large" ripple key="4" @click="relatedMaterialsClick" >Related Items</v-tab>
			<v-tab-item key="1" >
				<v-row v-if="bookCatsVisible">
						<v-col md4 style="margin-left: 10px;">
							<v-simple-table>
								<template v-slot:default>
									<tbody>
									<tr>
										<td><em>Current Category Assignments (click to delete)</em></td>
									</tr>
									<tr
											v-for="item in categoriesForBookArray"
											:key="item.ID"
											@click="categoryForBookClick(item.CATRECORDID,item.NAME)"
									>
										<td>{{ item.NAME }}</td>
									
									</tr>
									</tbody>
								</template>
							</v-simple-table>
							<v-row>
								<v-col md4 sm12>
									<v-btn @click="deleteCatFromBook" color="red">Delete Selected Cat.{{selectedCatName}} </v-btn>
								</v-col>
							</v-row>
						</v-col>
					<v-col>
						<v-simple-table>
							<template v-slot:default>
								<tbody>
								<tr>
									<td><em>Unused Category Assignments (click to add)</em></td>
								</tr>
								<tr
										v-for="item in availableCatsArray"
										:key="item.ID"
										@click="addCategory(item.ID,item.NAME)"
								>
									<td>{{ item.NAME }}</td>
								</tr>
								</tbody>
							</template>
						</v-simple-table>
						<v-row>
							<v-col md4 sm12>
								<v-btn @click="addCatToBook" color="blue">Add Selected Cat.{{newCatName}} </v-btn>
							</v-col>
						</v-row>
					</v-col>
					</v-row>
			</v-tab-item>
			<v-tab-item key="2">
				<v-row >
					<v-col md4 style="margin-left: 10px;">
						<v-btn color="green" style="margin-top: 10px" @click="prepareNewEdition">Add New Edition</v-btn>
						<v-simple-table>
							<template v-slot:default>
								<tbody>
								<tr>
									<td><em>Format</em></td>
									<td><em>Price</em></td>
									<td><em>Grams</em></td>
									<td><em>ISBN</em></td>
									<td><em>Not For Sale</em></td>
									<td><em>Out of Print</em></td>
								</tr>
								<tr
										v-for="item in editionsArray"
										:key="item.ID"
										@click="editEdition(item.ID)"
								>
									<td>{{ item.FORMAT }}</td>
									<td>${{ item.PRICE }}</td>
									<td>{{ item.GRAMS }}</td>
									<td>{{ item.ISBN }}</td>
									<td> <v-simple-checkbox v-model="item.NOT_FOR_SALE" disabled></v-simple-checkbox> </td>
									<td> <v-simple-checkbox v-model="item.OUT_OF_PRINT" disabled></v-simple-checkbox> </td>
								</tr>
								</tbody>
							</template>
						</v-simple-table>
					</v-col>
				</v-row>
				<v-row v-if="editionEdit" >
					<v-col md2 sm12 style="margin-left: 10px;">
						<v-text-field v-model="editionObject.FORMAT" label="Format"></v-text-field>
					</v-col>
					<v-col md2 sm12 style="margin-left: 10px;">
						<v-text-field v-model="editionObject.PRICE" label="Price"></v-text-field>
					</v-col>
					<v-col md2 sm12 style="margin-left: 10px;">
						<v-text-field v-model="editionObject.GRAMS" label="Grams"></v-text-field>
					</v-col>
					<v-col md2 sm12 style="margin-left: 10px;">
						<v-text-field v-model="editionObject.ISBN" label="ISBN"></v-text-field>
					</v-col>
					<v-col md2 sm12 style="margin-left: 10px;">
						<v-checkbox v-model="editionObject.NOT_FOR_SALE" label="Note For Sale"></v-checkbox>
					</v-col>
					<v-col md2 sm12 style="margin-left: 10px;">
						<v-checkbox v-model="editionObject.OUT_OF_PRINT" label="Out of Print"></v-checkbox>
					</v-col>
				</v-row>
				<v-row>
					<v-col v-if="editionEdit" md3 sm12 style="margin-left: 10px;">
						<v-btn color="green" @click="updateEdition">Save Edition Edits</v-btn>
					</v-col>
				</v-row>
				<v-row v-if="editionAdd" >
					<v-col md2 sm12 style="margin-left: 10px;">
						<v-text-field v-model="editionObject.FORMAT" label="Format"></v-text-field>
					</v-col>
					<v-col md2 sm12 style="margin-left: 10px;">
						<v-text-field v-model="editionObject.PRICE" label="Price"></v-text-field>
					</v-col>
					<v-col md2 sm12 style="margin-left: 10px;">
						<v-text-field v-model="editionObject.GRAMS" label="Grams"></v-text-field>
					</v-col>
					<v-col md2 sm12 style="margin-left: 10px;">
						<v-text-field v-model="editionObject.ISBN" label="ISBN"></v-text-field>
					</v-col>
					<v-col md2 sm12 style="margin-left: 10px;">
						<v-checkbox v-model="editionObject.NOT_FOR_SALE" label="Note For Sale"></v-checkbox>
					</v-col>
					<v-col md2 sm12 style="margin-left: 10px;">
						<v-checkbox v-model="editionObject.OUT_OF_PRINT" label="Out of Print"></v-checkbox>
					</v-col>
				</v-row>
				<v-row>
					<v-col v-if="editionAdd" md3 sm12 style="margin-left: 10px;">
						<v-btn color="green" @click="saveNewEdition">Save New Edition</v-btn>
					</v-col>
				</v-row>
			</v-tab-item>
			<v-tab-item key="3">
				<v-row >
					<v-col md4 style="margin-left: 10px;">
						<v-row>
							<v-col md4 style="margin-left: 10px;">
								<v-btn color="green" style="margin-top: 10px" @click="addHero">Add New Hero</v-btn>
							</v-col>
							<v-col md4 style="margin-left: 10px;">
								<v-btn color="green" style="margin-top: 10px" @click="addPortrait">Add New Portrait</v-btn>
							</v-col>
							<v-col md4 style="margin-left: 10px;">
								<v-btn color="green" style="margin-top: 10px" @click="addSpread">Add New Spread</v-btn>
							</v-col>
						</v-row>
						<v-simple-table>
							<template v-slot:default>
								<tbody>
								<tr>
									<td><em>Position</em></td>
									<td><em>Filename</em></td>
									<td><em>AssetType</em></td>
								</tr>
								<tr
										v-for="item in assetsArray"
										:key="item.ID"
										@click="setAsset(item.ID)"
								>
									<td>{{ item.POSITION }}</td>
									<td>{{ item.FILENAME }}</td>
									
									<td>{{ item.TYPELABLE }}</td>
								</tr>
								</tbody>
							</template>
						</v-simple-table>
					</v-col>
				</v-row>
				<v-row v-if="assetEditMode">
					<v-col md4 style="margin-left: 10px;" sm12>
						<v-text-field v-model="assetObject.POSITION" label="Position" >
						</v-text-field>
					</v-col>
					<v-col md3 sm12>
						<v-select
								label="Asset Type "
								v-model="assetObject.ASSETPHOTOTYPE"
								:items="assetTypesArray"
								item-text="ASSETLABLE"
								item-value="ID"
						></v-select>
					</v-col>
					<v-col md3 sm12 v-if="assetObject.FILENAME">
						<v-text-field v-model="assetObject.FILENAME" disabled label="filename"></v-text-field>
					</v-col>
				</v-row>
				<v-row  >
					<v-col md2 style="margin-left: 2px;"   >
						<div class="DashboardContainer" id="uppyHolder" style="display:none">Edit Asset</div>
						<div class="DashboardContainer" id="uppyHolder2" style="display:none">Edit Asset</div>
						<div class="DashboardContainer" id="uppyHolder3" style="display:none">Edit Asset</div>
					</v-col>
					<v-col md3 sm12 v-if="assetObject.FILENAME">
						<v-img v-if="assetObject.ASSETPHOTOTYPE ==3"
								:src="'https://eakinspress.com/images/heroes/heroesCompressed/' + assetObject.FILENAME"
								style="max-width: 60%"
						></v-img>
						<v-img v-if="assetObject.ASSETPHOTOTYPE ==1" :src="'https://eakinspress.com/images/portraits/portraitsCompressed/' + assetObject.FILENAME" style="max-width: 60%"
						></v-img>
						<v-img v-if="assetObject.ASSETPHOTOTYPE ==2" :src="'https://eakinspress.com/images/publications/spreadsCompressed/' + assetObject.FILENAME" style="max-width: 60%"
						></v-img>
						<v-btn v-if="assetEditMode" @click="saveAssetChanges" color="blue">Save Asset Changes</v-btn>
						<v-btn v-if="assetEditMode" @click="deleteAsset" color="red">Delete Asset</v-btn>
					</v-col>
				</v-row>
				<v-row v-if="assetAddMode">
					<v-col md4 style="margin-left: 10px;" sm12>
						<v-text-field v-model="assetObject.POSITION" label="Position" >
						</v-text-field>
					</v-col>
					<v-col md3 sm12 >
						<v-text-field v-model="assetObject.NEWFILENAME"  disabled label="filename"></v-text-field>
					</v-col>
				</v-row>
				<v-row >
					<v-col md2 style="margin-left: 2px;"   >
						<div class="DashboardContainer" id="uppyHolder4" style="display:none">Edit Asset</div>
						<div class="DashboardContainer" id="uppyHolder5" style="display:none">Edit Asset</div>
						<div class="DashboardContainer" id="uppyHolder6" style="display:none">Edit Asset</div>
						<v-btn v-if="assetAddMode" @click="createNewAsset" color="blue">Save New {{ newAssetType }} </v-btn>
					</v-col>
				</v-row>
			</v-tab-item>
			<v-tab-item key="4">
				<v-row >
					<v-col md4 style="margin-left: 10px;">
						<v-simple-table>
							<template v-slot:default>
								<tbody>
								<tr>
									<td><em>Title</em></td>
									<td><em>Type</em></td>
								</tr>
								<tr
										v-for="item in relatedItemsArray"
										:key="item.ID"
										@click="editRelatedItem(item.ID)"
								>
									<td>{{ item.TITLE }}</td>
									<td>{{ item.CLASSNAME }}</td>
								</tr>
								</tbody>
							</template>
						</v-simple-table>
					</v-col>
				</v-row>
				<v-row >
					<v-col md2 sm12 style="margin-left: 10px;" v-if="!relatedItemAdd">
						<v-btn color="green" @click="setUpNewRelatedItem">Add New Related Item</v-btn>
					</v-col>
				</v-row>
				<v-row v-if="relatedItemEdit" >
					<v-col md2 sm12 style="margin-left: 10px;">
						<v-text-field v-model="relatedItemObject.TITLE" label="Title"></v-text-field>
					</v-col>
					<v-col md8 sm12 style="margin-left: 10px;">
						<v-text-field v-model="relatedItemObject.LINK" label="Link"></v-text-field>
					</v-col>
					<v-col md1 sm12 style="margin-left: 10px;">
						<v-checkbox v-model="relatedItemObject.PUBLISH" label="Publish"></v-checkbox>
					</v-col>
				</v-row>
				<v-row v-if="relatedItemEdit" >
					<v-col md6 sm12 style="margin-left: 10px;">
					<v-text-field label="Content" disabled></v-text-field>
					<ckeditor
							:editor="editor"
							v-model="relatedItemObject.CONTENT"
							:config="editorConfig"
							label="Content"
					></ckeditor>
					</v-col>
					<v-col md3 sm12>
						<v-select
								label="Asset Type "
								v-model="relatedItemObject.RELATEDITEMCLASS"
								:items="relatedClasses"
								item-text="CLASSNAME"
								item-value="ID"
						></v-select>
					</v-col>
				</v-row>
				<v-row v-if="relatedItemAdd" >
					<v-col md2 sm12 style="margin-left: 10px;">
						<v-text-field v-model="relatedItemObject.TITLE" label="Title"></v-text-field>
					</v-col>
					<v-col md8 sm12 style="margin-left: 10px;">
						<v-text-field v-model="relatedItemObject.LINK" label="Link"></v-text-field>
					</v-col>
					<v-col md1 sm12 style="margin-left: 10px;">
						<v-checkbox v-model="relatedItemObject.PUBLISH" label="Publish"></v-checkbox>
					</v-col>
				</v-row>
				<v-row v-if="relatedItemAdd" >
					<v-col md6 sm12 style="margin-left: 10px;">
						<v-text-field label="Content" disabled></v-text-field>
						<ckeditor
								:editor="editor"
								v-model="relatedItemObject.CONTENT"
								:config="editorConfig"
								label="Content"
						></ckeditor>
					</v-col>
					<v-col md3 sm12>
						<v-select
								label="Asset Type "
								v-model="relatedItemObject.RELATEDITEMCLASS"
								:items="relatedClasses"
								item-text="CLASSNAME"
								item-value="ID"
						></v-select>
					</v-col>
				</v-row>
				<v-row v-if="relatedItemEdit" >
					<v-col md4>
						<v-btn color="blue" @click="saveRelated">Save Related Item Edits</v-btn>
					</v-col>
				</v-row>
				<v-row >
					<v-col v-if="relatedItemAdd" md3 sm12 style="margin-left: 10px;">
						<v-btn color="green" @click="saveNewRelatedItem">Save New Related Item</v-btn>
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
require("@uppy/core/dist/style.css");
require("@uppy/dashboard/dist/style.css");

export default {
	name: "BookDetail",
	data: () => ({
		dataURL: "https://eakinspress.com/data/data/eakinsAdmin.cfc?",
		editMode: false,
		addMode: false,
		bookArray: [],
		bookObject:{},
		editionsArray:[],
		editionObject:{},
		bookID:null,
		timeout: 1000,
		editor: ClassicEditor,
		editorData: "",
		editorConfig: {},
		categoriesForBookArray:[],
		categoryForBookObject:{},
		bookCatsVisible:false,
		availableCatsArray:[],
		currentCatRecordID:null,
		selectedCatName:'',
		newCatName:'',
		selectedNewCatID:null,
		text:'Saved',
		snackbar: false,
		editionEdit:false,
		editionAdd:false,
		singleEditionArray:[],
		assetsArray:[],
		assetObject:{},
		assetArray:[],
		assetTypesArray:[],
		assetEditMode:false,
		endpoint:"/uploadHomePageImages.cfm" ,
		currentPhotoType:0,
		uppyVersionInitialized:0,
		uppyArray:[],
		assetAddMode:false,
		newAssetType:'',
		relatedItemsArray:[],
		relatedItemArray:[],
		relatedItemObject:{},
		relatedItemEdit:false,
		relatedItemAdd:false,
		relatedClasses:[],

		
	}),
	methods:{
		saveNewRelatedItem(){
			let vm = this;
			vm.relatedItemObject.book_id = vm.bookID;
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				data: {
					method: "insertNewRelatedItem",
					relatedItemObject: JSON.stringify(vm.relatedItemObject)
				},
				success: function() {
					vm.snackbar = true;
					vm.relatedItemAdd = false;
					vm.relatedMaterialsClick();
					vm.clearRelatedItemObject();
					vm.relatedItemEdit = false;
					
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
		
		setUpNewRelatedItem(){
		this.relatedItemEdit = false;
		this.relatedItemAdd = true;
		this.clearRelatedItemObject();
		},
		
		
		clearRelatedItemObject(){
			let vm = this;
			vm.relatedItemObject.PUBLISH = 0;
			vm.relatedItemObject.CONTENT = ''
			vm.relatedItemObject.ID = 0;
			vm.relatedItemObject.LINK = '';
			vm.relatedItemObject.RELATEDITEMCLASS = 0;
			vm.relatedItemObject.TITLE = '';
		},
		
		
		
		saveRelated:function(){
			let vm = this;
			vm.relatedItemObject.book_id = vm.bookID;
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				data: {
					method: "updateRelatedItem",
					relatedItemObject: JSON.stringify(vm.relatedItemObject)
				},
				success: function() {
					vm.snackbar = true;
					vm.assetAddMode = false;
					vm.relatedMaterialsClick();
					vm.clearRelatedItemObject();
					vm.relatedItemEdit = false;
					
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
		
		getRelatedClasses(){
			let vm = this;
			axios.get(vm.dataURL + 'method=getRelatedClassNames')
			.then(function (response){
				vm.relatedClasses = response.data.results;
			})
			
		},
		
		editRelatedItem(relatedItemID){
			let vm = this;
			vm.relatedItemAdd = false;
			vm.relatedItemEdit = true;
			axios.get(vm.dataURL + 'method=getRelatedDetails&id=' + relatedItemID)
			.then(function (response){
				vm.relatedItemArray = response.data.results;
				vm.relatedItemObject = vm.relatedItemArray[0];
				vm.$vuetify.goTo(vm.pageHeight);
			})
			
		},
		
		relatedMaterialsClick(){
			let vm = this;
			axios.get(vm.dataURL + 'method=getRelatedItemsForBook&BOOK_ID=' + vm.bookID)
			.then(function(response){
				vm.relatedItemsArray = response.data.results;
				vm.getRelatedClasses();
			})
		},
		
		
		createNewAsset(){
			let vm = this;
			vm.assetObject.bookID = vm.bookID;
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				data: {
					method: "createNewAsset",
					assetObject: JSON.stringify(vm.assetObject)
				},
				success: function() {
					vm.snackbar = true;
					vm.assetAddMode = false;
					window.$('#uppyHolder4').css('display', 'none');
					vm.getAssetsForBook();
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
		
		saveAssetChanges(){
			let vm = this;
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				data: {
					method: "updateAsset",
					assetObject: JSON.stringify(vm.assetObject)
				},
				success: function() {
					vm.snackbar = true;
					vm.assetEditMode = false;
					vm.prepareUppyVisibility();
					vm.getAssetsForBook();
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
		deleteAsset(){
			let vm = this;
			vm.assetEditMode = true;
			axios.get(vm.dataURL + 'method=removeAsset&ID=' + vm.assetObject.ID)
					.then(function (){
						vm.assetEditMode = false;
						vm.getAssetsForBook();
					})
			
		},
		setAsset(id){
			let vm = this;
			vm.assetAddMode = false;
			vm.assetEditMode = true;
			axios.get(vm.dataURL + 'method=getIndividualAsset&id=' + id)
					.then(function(response){
						vm.assetArray = response.data.results;
						vm.assetObject = vm.assetArray[0];
						vm.currentPhotoType=  vm.assetObject.ASSETPHOTOTYPE;
						vm.prepareUppyVisibility();
						if(vm.assetObject.ASSETPHOTOTYPE ==3) {
							vm.endpoint = '/images/heroes/uploadHeroes.cfm';
							window.$('#uppyHolder2').css('display', 'none');
							window.$('#uppyHolder3').css('display', 'none');
							window.$('#uppyHolder4').css('display', 'none');
							window.$('#uppyHolder5').css('display', 'none');
							window.$('#uppyHolder6').css('display', 'none');
							window.$('#uppyHolder').css('display', 'inline-block');
							if (!vm.uppyArray.includes(3)) {
								vm.uppyArray.push(3);
								vm.initUppy();
							}
						}
						if(vm.assetObject.ASSETPHOTOTYPE ==1){
							vm.endpoint = '/images/portraits/upload.cfm'
							window.$('#uppyHolder').css('display', 'none');
							window.$('#uppyHolder3').css('display', 'none');
							window.$('#uppyHolder4').css('display', 'none');
							window.$('#uppyHolder2').css('display', 'inline-block');
							window.$('#uppyHolder5').css('display', 'none');
							window.$('#uppyHolder6').css('display', 'none');
							if (!vm.uppyArray.includes(1)) {
								vm.uppyArray.push(1);
								vm.initUppy2();
							}
						}
						if (vm.assetObject.ASSETPHOTOTYPE ==2) {
							vm.endpoint = '/images/publications/uploadSpreads.cfm'
							window.$('#uppyHolder').css('display', 'none');
							window.$('#uppyHolder2').css('display', 'none');
							window.$('#uppyHolder4').css('display', 'none');
							window.$('#uppyHolder3').css('display', 'inline-block');
							window.$('#uppyHolder5').css('display', 'none');
							window.$('#uppyHolder6').css('display', 'none');
							if (!vm.uppyArray.includes(2)) {
								vm.uppyArray.push(2);
								vm.initUppy3();
							}
						}
						// if (vm.uppyUp){
						// 	vm.uppy.close();
						// }
						
			});
			
		},
		prepareUppyVisibility(){
			window.$('#uppyHolder').css('display', 'none');
			window.$('#uppyHolder2').css('display', 'none');
			window.$('#uppyHolder3').css('display', 'none');
			window.$('#uppyHolder4').css('display', 'none');
			window.$('#uppyHolder5').css('display', 'none');
			window.$('#uppyHolder6').css('display', 'none');
		},
		clearBookObject(){
			let vm = this;
			vm.bookObject.COLOPHON = '';
			vm.bookObject.CREDITS = '';
			vm.bookObject.ID = -1;
			vm.bookObject.LONG_DESCRIPTION = '';
			vm.bookObject.SLUG = '';
			vm.bookObject.SPECS = '';
			vm.bookObject.SUBTITLE = '';
			vm.bookObject.TITLE = '';
			vm.bookObject.YEAR = '';
		},
		
		
		saveNewBook(){
			let vm = this;
			if (!vm.bookObject.YEAR) {
				vm.bookObject.YEAR = 1;
			}
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				data: {
					method: "createNewBook",
					bookObject: JSON.stringify(vm.bookObject)
				},
				success: function() {
					vm.snackbar = true;
					vm.addMode = false;
					vm.editMode = true;
					vm.getNewID();
					
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
				vm.bookObject.ID = response.data.DATA[0];
			});
		},
		
		clearEditionObject(){
			let vm = this;
			vm.editionObject.GRAMS = '';
			vm.editionObject.ISBN = '';
			vm.editionObject.PRICE = '';
			vm.editionObject.FORMAT = '';
			vm.editionObject.NOT_FOR_SALE = '';
			vm.editionObject.OUT_OF_PRINT = '';
			for (let [key, value] of Object.entries(vm.editionObject)) {
				if (key == 'NOT_FOR_SALE' || key == 'OUT_OF_PRINT'){
					value = 0;
				} else {
					value = '';
				}
				console.log(`${key}: ${value}`);
			}
			
			
			
		},
		saveNewEdition(){
			let vm = this;
			vm.editionObject.BOOK_ID = vm.bookID;
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				data: {
					method: "createNewEdition",
					editionObject: JSON.stringify(vm.editionObject)
				},
				success: function() {
					vm.snackbar = true;
					vm.editionAdd = false;
					vm.getEditionsForBook();
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
		
		prepareNewEdition(){
			this.editionEdit = false;
			this.editionAdd = true;
			this.clearEditionObject();
			
		},
		updateEdition(){
			let vm = this;
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				data: {
					method: "updateEdition",
					editionObject: JSON.stringify(vm.editionObject)
				},
				success: function() {
					vm.snackbar = true;
					vm.editionEdit = false;
					vm.getEditionsForBook();
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
		
		editEdition(editionID){
			let vm = this;
			axios.get(vm.dataURL + 'method=getEditionDetails&id=' + editionID)
					.then(function(response){
						vm.singleEditionArray = response.data.results;
						vm.editionObject = vm.singleEditionArray[0];
						vm.editionEdit = true;
						vm.$vuetify.goTo(vm.pageHeight);
				})
		},
		
		updateBook(){
			let vm = this;
			window.$.ajax({
				type: "post",
				url: vm.dataURL,
				dataType: "json",
				data: {
					method: "updateBook",
					bookDetails: JSON.stringify(vm.bookObject)
				},
				success: function() {
					vm.snackbar = true;
					vm.addMode = false;
					vm.editMode = true;
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
		
		deleteCatFromBook(){
			let vm = this;
			axios.get(vm.dataURL + 'method=deleteCatFromBook&catRecordID=' + vm.currentCatRecordID)
			.then(function (){
				vm.newCatName = '';
				vm.bookCatsClick();
				vm.getAvailableBookCategories();
			})
		},
		
		addCatToBook(){
			let vm = this;
			axios.get(vm.dataURL + 'method=newCatForBook&book_id=' + vm.bookID + '&category_id=' + vm.selectedNewCatID)
			.then(function (){
				vm.selectedCatName = '';
				vm.bookCatsClick();
				vm.getAvailableBookCategories();
				
			})
		},
		
		categoryForBookClick(catRecordID,catName){
			this.selectedCatName = catName;
			this.currentCatRecordID = catRecordID;
		},
		
		addCategory(catID,catName) {
			this.newCatName = catName;
			this.selectedNewCatID = catID;
		},
		
		bookCatsClick(){
			let vm = this;
			axios.get(vm.dataURL + 'method=getCategoriesForBook&id=' + vm.bookID)
			.then(function (response){
				vm.categoriesForBookArray = response.data.results;
				vm.bookCatsVisible = true;
				vm.getAvailableBookCategories();
				vm.$vuetify.goTo(vm.pageHeight);
			})
		},
		getAvailableBookCategories(){
			let vm = this;
			axios.get(vm.dataURL + 'method=getAvailableCategories&id=' + vm.bookID)
					.then(function (response){
						vm.availableCatsArray = response.data.results;
					})
		},
		bookEditionsClick(){                                 ``
		
		},
		bookAssetsClick(){
			this.getAssetTypes();
			this.getAssetsForBook();
		},
		getBookDetails(){
			let vm = this;
			axios.get(vm.dataURL + 'method=getBookDetails&id=' + vm.bookID)
			.then(function (response){
				vm.bookArray = response.data.results;
				vm.bookObject = vm.bookArray[0];
				vm.bookObject.LONG_DESCRIPTION = vm.bookObject.LONG_DESCRIPTION.replace(
						/[\u2018\u2019]/g, "'").replace(/[\u201C\u201D]/g, '"');
				vm.getEditionsForBook();
			})
		},
		getAssetsForBook(){
			let vm = this;
			axios.get(vm.dataURL + 'method=getAssetsForBook&book_id=' + vm.bookID)
			.then(function (response){
				vm.assetsArray = response.data.results;
				console.log(vm.assetsArray);
			})
		},
		getAssetTypes(){
			let vm = this;
			axios.get(vm.dataURL + 'method=getAssetTypes')
			.then(function (response){
				vm.assetTypesArray = response.data.results;
			})
		},
		initUppy() {
			const uppyLarge = new Uppy({ debug: true,allowMultipleUploads: false   })
					
					.use(Dashboard, {
						trigger: ".UppyModalOpenerBtn",
						inline: true,
						target: "#uppyHolder",
						height: 400,
						id:'uppy'
					})
					.use(XHRUpload, {
						endpoint: '/images/heroes/uploadHeroes.cfm',
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
				this.assetObject.FILENAME = result.successful[0].name;
				
			});
		},
		initUppy2() {
			
			this.uppyVersionInitialized=1;
			const uppyLarge = new Uppy({ debug: true,allowMultipleUploads: false  })
					
					.use(Dashboard, {
						trigger: ".UppyModalOpenerBtn",
						inline: true,
						target: "#uppyHolder2",
						height: 300,
						id:'uppy2'
					})
					.use(XHRUpload, {
						endpoint: '/images/publications/uploadSpreads.cfm',
						formData: true,
						fieldName: "fileData" ,
						// headers: {
						// 	encType:'multipart/form-data',
						// 	contentType: 'multipart/form-data'
						// }
					});
			
			uppyLarge.on("complete", result => {
				// eslint-disable-next-line
				console.log(
						"Upload complete! We’ve uploaded these files:",
						result.successful
				);
				this.assetObject.FILENAME = result.successful[0].name;
				
			});
		},
		initUppy3() {
			
			this.uppyVersionInitialized=2;
			const uppyLarge = new Uppy({ debug: true,allowMultipleUploads: false  })
					
					.use(Dashboard, {
						trigger: ".UppyModalOpenerBtn",
						inline: true,
						target: "#uppyHolder3",
						height: 300,
						id:'uppy3'
					})
					.use(XHRUpload, {
						endpoint: '/images/portraits/upload.cfm',
						formData: true,
						fieldName: "fileData",
						// headers: {
						// 	encType:'multipart/form-data',
						// 	contentType: 'multipart/form-data'
						// }
					});
			
			uppyLarge.on("complete", result => {
				// eslint-disable-next-line
				console.log(
						"Upload complete! We’ve uploaded these files:",
						result.successful
				);
				this.assetObject.FILENAME = result.successful[0].name;
				
			});
		},
		
		addHero(){
			let vm = this;
			vm.assetEditMode = false;
			vm.assetAddMode = true;
			vm.newAssetType = 'Hero';
			vm.endpoint = '/images/heroes/uploadHeroes.cfm';
			vm.assetObject.ASSETPHOTOTYPE =3 ;
			if (!vm.assetObject.POSITION)  {
				vm.assetObject.POSITION = 1;
			}
			vm.assetObject.FILENAME = '';
			window.$('#uppyHolder').css('display', 'none');
			window.$('#uppyHolder2').css('display', 'none');
			window.$('#uppyHolder3').css('display', 'none');
			window.$('#uppyHolder5').css('display', 'none');
			window.$('#uppyHolder6').css('display', 'none');
			window.$('#uppyHolder4').css('display', 'inline-block');
			if (!vm.uppyArray.includes(4)) {
				vm.uppyArray.push(4);
				vm.initUppy4();
			}
		},
		
		addPortrait(){
			let vm = this;
			vm.assetEditMode = false;
			vm.assetAddMode = true;
			vm.newAssetType = 'Portrait';
			vm.endpoint = '/images/portraits/upload.cfm';
			vm.assetObject.ASSETPHOTOTYPE =1 ;
			if (!vm.assetObject.POSITION)  {
	

				vm.assetObject.POSITION = 0;
			}
			vm.assetObject.FILENAME = '';
			window.$('#uppyHolder').css('display', 'none');
			window.$('#uppyHolder2').css('display', 'none');
			window.$('#uppyHolder3').css('display', 'none');
			window.$('#uppyHolder4').css('display', 'none');
			window.$('#uppyHolder5').css('display', 'inline-block');
			window.$('#uppyHolder6').css('display', 'none');
			if (!vm.uppyArray.includes(5)) {
				vm.uppyArray.push(5);
				vm.initUppy5();
			}
		},
		addSpread(){
			let vm = this;
			vm.assetEditMode = false;
			vm.assetAddMode = true;
			vm.newAssetType = 'Spread';
			vm.endpoint = '/images/publications/uploadSpreads.cfm';
			vm.assetObject.ASSETPHOTOTYPE =2 ;
			vm.assetObject.FILENAME = '';
			if (!vm.assetObject.POSITION)  {
				vm.assetObject.POSITION = 1;
			}
			window.$('#uppyHolder').css('display', 'none');
			window.$('#uppyHolder2').css('display', 'none');
			window.$('#uppyHolder3').css('display', 'none');
			window.$('#uppyHolder4').css('display', 'none');
			window.$('#uppyHolder5').css('display', 'none');
			window.$('#uppyHolder6').css('display', 'inline-block');
			if (!vm.uppyArray.includes(6)) {
				vm.uppyArray.push(6);
				vm.initUppy6();
			}
		},
		
		initUppy4() {
			const endpoint = this.endpoint;
			const uppyLarge = new Uppy({ debug: true,allowMultipleUploads: false  })
					
					.use(Dashboard, {
						trigger: ".UppyModalOpenerBtn",
						inline: true,
						target: "#uppyHolder4",
						height: 300,
						id:'uppy4'
					})
					.use(XHRUpload, {
						endpoint: endpoint,
						formData: true,
						fieldName: "fileData"
					});
			
			uppyLarge.on("complete", result => {
				// eslint-disable-next-line
				// console.log(
				// 		"Upload complete! We’ve uploaded these files:",
				// 		result.successful
				// );
				this.assetObject.FILENAME = result.successful[0].name;
				this.assetObject.NEWFILENAME =  result.successful[0].name
				
			});
		},
		initUppy5() {
			const endpoint = this.endpoint;
			const uppyLarge = new Uppy({ debug: true,allowMultipleUploads: false  })
					
					.use(Dashboard, {
						trigger: ".UppyModalOpenerBtn",
						inline: true,
						target: "#uppyHolder5",
						height: 300,
						id:'uppy5'
					})
					.use(XHRUpload, {
						endpoint: endpoint,
						formData: true,
						fieldName: "fileData"
					});
			
			uppyLarge.on("complete", result => {
				//eslint-disable-next-line
				console.log(
						"Upload complete! We’ve uploaded these files:",
						result.successful
				);
				this.assetObject.FILENAME = result.successful[0].name;
				this.assetObject.NEWFILENAME =  result.successful[0].name
				
			});
		},
		initUppy6() {
			const endpoint = this.endpoint;
			const uppyLarge = new Uppy({ debug: true,allowMultipleUploads: false })
					
					.use(Dashboard, {
						trigger: ".UppyModalOpenerBtn",
						inline: true,
						target: "#uppyHolder6",
						height: 300,
						id:'uppy6'
					})
					.use(XHRUpload, {
						endpoint: endpoint,
						formData: true,
						fieldName: "fileData"
					});
			
			uppyLarge.on("complete", result => {
				//eslint-disable-next-line
				console.log(
						"Upload complete! We’ve uploaded these files:",
						result.successful
				);
				this.assetObject.FILENAME = result.successful[0].name;
				this.assetObject.NEWFILENAME =  result.successful[0].name
				
				
			});
		},
		
		getEditionsForBook(){
			let vm = this;
			axios.get(vm.dataURL + 'method=getEditionsForBook&id=' + vm.bookID)
					.then(function (response){
						vm.editionsArray = response.data.results;
						vm.editionsArray.forEach(function(book){
							if (book.OUT_OF_PRINT == 1){
								book.OUT_OF_PRINT = true;
							}else{
								book.OUT_OF_PRINT = false;
							}
						})
						vm.editionsArray.forEach(function(book){
							if (book.NOT_FOR_SALE == 1){
								book.NOT_FOR_SALE = true;
							}else{
								book.NOT_FOR_SALE = false;
							}
						})
						
					})
		},
	},
	
	mounted() {
		if (this.$route.params.id < 1) {
			this.editMode = false;
			this.addMode = true;
			this.clearBookObject();
		} else {
			this.bookID = this.$route.params.id;
			this.getBookDetails();
			this.editMode = true;
			this.uppyArray=[];
		}
	},
	computed: {
		pageHeight () {
			return document.body.scrollHeight
		}
	}
}
</script>

<style scoped>
.v-application a{
	color: black;
}
</style>
