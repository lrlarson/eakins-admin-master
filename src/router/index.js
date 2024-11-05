import Vue from 'vue'
import VueRouter from 'vue-router'
import SignIn from '@/components/SignIn'
import Home from "@/components/Home";
import Books from "@/components/Books";
import BookDetail from "@/components/BookDetail";
import DanceIndex from "@/components/DanceIndex";
import DanceIndexDetail from "@/components/DanceIndexDetail";
import FrontPageControl from "@/components/FrontPageControl";
import DanceIndexPurchases from "@/components/DanceIndexPurchases";
import Customers from "@/components/Customers.vue";
import CustomerOrders from "@/components/CustomerOrders.vue";
import OrderDetails from "@/components/OrderDetails.vue";
import Products from "@/components/Products.vue";
import ProductHistory from "@/components/ProductHistory.vue";
import AddNewCustomer from "@/components/AddNewCustomer.vue";

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'SignIn',
    component: SignIn
  },
  {
    path: '/Home',
    name: 'Home',
    component: Home
  },
  {
    path: '/Books' ,
    name:'Books',
    component: Books
  },
  {
    path: "/Book-Detail/:id",
    name: "Book-Detail",
    component: BookDetail
  },
  {
    path:'/DanceIndex',
    name:'DanceIndex',
    component: DanceIndex
  },
  {
    path: "/DanceIndexDetail/:id",
    name: "DanceIndexDetail",
    component: DanceIndexDetail
  },
  {
    path: "/FrontPageControl",
    name: "FrontPageControl",
    component: FrontPageControl
  },
  {
    path: "/DanceIndexPurchases",
    name: "DanceIndexPurchases",
    component: DanceIndexPurchases
  },
  {
    path:"/Customers",
    name:"Customers",
    component: Customers
  },
  {
    path: "/CustomerOrders/:snipcart_ID",
    name: "CustomerOrders",
    component: CustomerOrders
  },
  {
    path: "/OrderDetails/:trans_ID",
    name: "OrderDetails",
    component: OrderDetails
  },
  {
    path: "/ProductHistory/:product_ID",
    name: "ProductHistory",
    component: ProductHistory
  },
  {
    path: "/Products",
    name: "Products",
    component: Products
  },
  {
    path: "/AddNewCustomer",
    name: "AddNewCustomer",
    component: AddNewCustomer
  },
]

const router = new VueRouter({
  routes
})

export default router
