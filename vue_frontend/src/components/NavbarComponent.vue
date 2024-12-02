<template>
  <nav>
    <!-- Drawer para usuarios logueados -->
    <div v-if="isLoggedIn" class="drawer-container">
      <!-- Botón para abrir/cerrar el Drawer -->
      <button class="drawer-toggle" @click="toggleDrawer">
        <i class="icon">☰</i>
      </button>

      <!-- Contenedor del Drawer -->
      <div v-if="isDrawerOpen" class="drawer-menu">
        <ul class="drawer-list">
          <li>
            <router-link to="/config-user">
              <i class="icon">⚙️ </i> Configuración
            </router-link>
          </li>
          <li>
            <router-link to="/publish-user">
              <i class="icon">📝 </i> Publicar
            </router-link>
          </li>
          <li>
            <router-link to="/sighting-user">
              <i class="icon">🔍 </i> Avistamiento
            </router-link>
          </li>
          <li>
            <router-link to="/saved-post-user">
              <i class="icon">💾 </i> Publicaciones Guardadas
            </router-link>
          </li>
        </ul>
      </div>
    </div>

    <!-- Logo -->
    <div class="nav-logo">
      <img :src="logoIcon" alt="Logo" class="logo-img" />
      <h1>Find Your Pet, Go!</h1>
    </div>


       <!-- Sección de enlaces -->
    <ul v-if="!isLoggedIn" class="navbar-links">
      <li><router-link to="/">Inicio</router-link></li>
      <li><router-link to="/services">Servicios</router-link></li>
      <li><router-link to="/news">Noticias</router-link></li>
      <li><router-link to="/help">Servicio de Ayuda</router-link></li>
      <li><router-link to="/about">Sobre Nosotros</router-link></li>
    </ul>

    <ul v-if="isLoggedIn" class="navbar-links">
      <li><router-link to="/pets">Mascotas</router-link></li>
      <li><router-link to="/services-user">Servicios</router-link></li>
      <li><router-link to="/blog-user">Blog</router-link></li>
      <li><router-link to="/profile-user">Perfil</router-link></li>
    </ul>

    <!-- Información de usuario logueado -->
  <div v-if="isLoggedIn" class="user-info">
    <span>{{ userName }}</span>
    <div class="user-icon" @click="toggleUserMenu">
      <img :src="userIcon" alt="User Icon" class="user-img" />
      <div v-if="showUserMenu" class="user-menu">
        <button @click="logout">Cerrar Sesión</button>
      </div>
    </div>
  </div>


    <!-- Botones de autenticación para usuarios no logueados -->
    <div v-if="!isLoggedIn" class="auth-buttons">
      <router-link to="/registro">
        <button class="register-btn">Registrarse</button>
      </router-link>
      <router-link to="/iniciar-sesion">
        <button class="login-btn">Iniciar Sesión</button>
      </router-link>
    </div>
  </nav>
</template>

<script>
export default {
  data() {
    return {
      isLoggedIn: true, // Estado de autenticación
      userName: "", // Nombre del usuario
      isDrawerOpen: false, // Estado del menú Drawer
      userIcon: require("@/assets/user.png"), // Ruta de la imagen
      logoIcon: require("@/assets/dog.png"), // Ruta de la imagen del logo
      showUserMenu: false, // Menú de opciones del usuario
    };
  },
  created() {
    this.isLoggedIn = localStorage.getItem("UserToken");
    
    this.userName = localStorage.getItem("userName") || "Usuario";
  },
  methods: {
    toggleDrawer() {
      this.isDrawerOpen = !this.isDrawerOpen;
    },
    toggleUserMenu() {
      this.showUserMenu = !this.showUserMenu;
    },
    logout() {
      // Cerrar sesión
      localStorage.removeItem("UserToken");
      this.isLoggedIn=null;
      this.$router.push("/"); // Redirigir al inicio
    },
  },
};
</script>

<style scoped>
/* Contenedor principal del Navbar */
nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  background: linear-gradient(90deg, #8cbbcb, #00c8ff);
  color: white;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  position: sticky;
  top: 0;
  z-index: 1000;
}

/* Logo */
.nav-logo h1 {
  margin: 0;
  font-size: 1.5rem;
  color: white;
  font-weight: bold;
  display: inline-block;
}

/* Lista de enlaces */
.navbar-links {
  display: flex;
  gap: 1.5rem; /* Espaciado uniforme entre enlaces */
  margin: 0;
  padding: 0;
  list-style: none;
}

.navbar-links li a {
  color: white;
  text-decoration: none;
  font-weight: bold;
  transition: color 0.3s ease;
}

.navbar-links li a:hover {
  color: #a8e6ff;
}

/* Drawer */
.drawer-container {
  margin-right: 1rem;
  position: relative;
}

.drawer-toggle {
  background: none;
  border: none;
  font-size: 1.8rem;
  cursor: pointer;
  color: white;
}

.drawer-menu {
  position: absolute;
  top: 50px;
  left: 0;
  background: white;
  color: #0078d4;
  border: 1px solid #ccc;
  border-radius: 5px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  padding: 1rem;
  width: 250px;
}

.drawer-list {
  list-style: none;
  margin: 0;
  padding: 0;
}

.drawer-list li a {
  text-decoration: none;
  color: #0078d4;
  display: flex;
  align-items: center;
  padding: 0.5rem 0.8rem;
  font-weight: bold;
  transition: background 0.3s ease;
  border-radius: 5px;
}

.drawer-list li a:hover {
  background: #0078d4;
  color: white;
}

/* Usuario */
.user-info {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.user-icon {
  cursor: pointer;
}

.user-menu {
  position: absolute;
  top: 50px;
  right: 0;
  background: white;
  color: #0078d4;
  border: 1px solid #ccc;
  padding: 0.5rem;
  border-radius: 4px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  width: 150px;
}

.user-menu button {
  background: #0078d4;
  border: none;
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 5px;
  font-size: 1rem;
  cursor: pointer;
}

.user-menu button:hover {
  background: #005bb5;
}

/* Botones de autenticación */
.auth-buttons button {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 5px;
  font-weight: bold;
  cursor: pointer;
  font-size: 0.9rem;
  transition: background 0.3s ease, color 0.3s ease;
}

.register-btn {
  background-color: #00a8e8;
  color: white;
}

.register-btn:hover {
  background-color: #00c8ff;
}

.login-btn {
  background-color: #0078d4;
  color: white;
}

.login-btn:hover {
  background-color: #005bb5;
}

.user-img {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
  cursor: pointer;
}

.logo-img {
  width: 50px; /* Ajusta el tamaño del logo según lo necesites */
  height: 50px;
  margin-right: 10px; /* Espacio entre la imagen y el texto */
  vertical-align: -70%; /* Alinea el logo con el texto */
}

</style>
