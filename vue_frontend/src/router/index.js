import { createRouter, createWebHistory } from 'vue-router';

import HomePage from '../views/HomePage.vue';
import ServicesPage from '../views/ServicesPage.vue';
import NewsPage from '../views/NewsPage.vue';
import HelpPage from '../views/HelpPage.vue';
import AboutPage from '../views/AboutPage.vue';
import RegisterPage from '../views/RegisterPage.vue';
import LoginPage from '../views/LoginPage.vue';

const routes = [
  { path: '/', name: 'Inicio', component: HomePage },
  { path: '/servicios', name: 'Servicios', component: ServicesPage },
  { path: '/noticias', name: 'Noticias', component: NewsPage },
  { path: '/ayuda', name: 'Servicio de Ayuda', component: HelpPage },
  { path: '/sobre-nosotros', name: 'Sobre Nosotros', component: AboutPage },
  { path: '/registro', component: RegisterPage },
  { path: '/iniciar-sesion', component: LoginPage },
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

export default router;
