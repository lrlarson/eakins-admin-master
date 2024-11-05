<template>
	<v-app id="inspire">
		<v-navigation-drawer
				v-model="drawer"
				app
		>
			<v-list dense v-if="authenticated">
				
				
				<v-list-item link>
					<v-list-item-action>
						<router-link  to="/Home">Home
						</router-link>
					</v-list-item-action>
					<v-list-item-content>
						<v-list-item-title></v-list-item-title>
					</v-list-item-content>
				</v-list-item>
				
				<v-list-item link>
					<v-list-item-action>
						<router-link  to="/Books">Books
						</router-link>
					</v-list-item-action>
					<v-list-item-content>
						<v-list-item-title></v-list-item-title>
					</v-list-item-content>
				</v-list-item>
				
				<v-list-item link>
					<v-list-item-action>
						<router-link  to="/DanceIndex">Dance Index
						</router-link>
					</v-list-item-action>
					<v-list-item-content>
						<v-list-item-title></v-list-item-title>
					</v-list-item-content>
				</v-list-item>
				
				<v-list-item link>
					<v-list-item-action>
						<router-link  to="/FrontPageControl">Home Page Settings
						</router-link>
					</v-list-item-action>
					<v-list-item-content>
						<v-list-item-title></v-list-item-title>
					</v-list-item-content>
				</v-list-item>
				
				<v-list-item link>
					<v-list-item-action>
						<router-link  to="/DanceIndexPurchases">Dance Index Purchases
						</router-link>
					</v-list-item-action>
					<v-list-item-content>
						<v-list-item-title></v-list-item-title>
					</v-list-item-content>
				</v-list-item>
				
				<v-list-item link>
					<v-list-item-action>
						<router-link  to="/Customers">General Customers
						</router-link>
					</v-list-item-action>
					<v-list-item-content>
						<v-list-item-title></v-list-item-title>
					</v-list-item-content>
				</v-list-item>
				
				<v-list-item link>
					<v-list-item-action>
						<router-link  to="/Products">Web Purchased Products
						</router-link>
					</v-list-item-action>
					<v-list-item-content>
						<v-list-item-title></v-list-item-title>
					</v-list-item-content>
				</v-list-item>
				
				
			
			
			</v-list>
		</v-navigation-drawer>
		
		<v-app-bar
				app
				color="light grey"
				dark
		>
			<v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
			<v-toolbar-title>Eakins Press Editor App. Version: 4.0</v-toolbar-title>
		</v-app-bar>
		
		<v-main>
			<v-container
					class="fill-height"
					fluid
			>
				<router-view></router-view>
			</v-container>
		</v-main>
		<v-footer
				color="light grey"
				app
		>
			<span class="white--text">&copy;  {{ currentYear }} Eakins Press</span>
		</v-footer>
	</v-app>
</template>

<script>
import {eventBus} from "./main";
import moment from "moment";

export default {
	props: {
		source: String,
	},
	data: () => ({
		drawer: null,
		authenticated: false,     // temp sent to true,
		currentYear: ''
	}),
	created() {
		eventBus.$on("signedIn", () => {
			//console.log("signin");
			this.authenticated = true;
		});
		eventBus.$on("signInFail", () => {
			this.authenticated = false;
		});
		this.currentYear = moment().year();
	}
}
</script>
