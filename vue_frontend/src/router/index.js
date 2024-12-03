import { createRouter, createWebHistory } from 'vue-router';

// Importación de vistas
import HomePage from '../views/HomePage.vue';
import ServicesPage from '../views/ServicesPage.vue';
import NewsPage from '../views/NewsPage.vue';
import HelpPage from '../views/HelpPage.vue';
import AboutPage from '../views/AboutPage.vue';
import RegisterPage from '../views/RegisterPage.vue';
import LoginPage from '../views/LoginPage.vue';
import AdminPage from '../views/AdminPage.vue';
import PruebaPage from '../views/PruebaPage.vue';

// Páginas del usuario
import PetUser from '../views/user/PetUser.vue';
import ServicesUser from '../views/user/ServicesUser.vue';
import BlogUser from '../views/user/BlogUser.vue';
import ProfileUser from '../views/user/ProfileUser.vue';

// Páginas del Menu Drawer
import ConfigUser from '../views/user/ConfigUser.vue';
import PublishUser from '../views/user/PublishUser.vue';
import SightingUser from '../views/user/SightingUser.vue';
import SavedPostUser from '../views/user/SavedPostUser.vue';

// Páginas del Admin
import BreedsAdmin from '../views/admin/BreedsAdmin.vue';
import SpeciesAdmin from '../views/admin/SpeciesAdmin.vue';

const routes = [
  { path: '/', name: 'Home', component: HomePage },
  { path: '/services', name: 'Services', component: ServicesPage },
  { path: '/news', name: 'News', component: NewsPage },
  { path: '/help', name: 'Help', component: HelpPage },
  { path: '/about', name: 'About', component: AboutPage },
  { path: '/register', component: RegisterPage },
  { path: '/login', component: LoginPage },
  { path: '/admin', component: AdminPage },
  { path: '/prueba', component: PruebaPage },

  // Rutas del usuario
  { path: '/pets', name: 'Pets User', component: PetUser },
  { path: '/services-user', name: 'Services User', component: ServicesUser },
  { path: '/blog-user', name: 'Blog User', component: BlogUser },
  { path: '/profile-user', name: 'Profile User', component: ProfileUser },

  // Rutas del Menu Drawer
  { path: '/config-user', name: 'Settings User', component: ConfigUser },
  { path: '/publish-user', name: 'Post User', component: PublishUser },
  { path: '/sighting-user', name: 'Sighting User', component: SightingUser },
  { path: '/saved-post-user', name: 'Saved Posts User', component: SavedPostUser },

  // Rutas del Admin
  { path: '/breeds-admin', name: 'Breeds Admin', component: BreedsAdmin },
  { path: '/species-admin', name: 'Species Admin', component: SpeciesAdmin },
];

// Creación del router
const router = createRouter({
  history: createWebHistory(), // Cambiar a createWebHashHistory si es necesario
  routes,
});

export default router;
