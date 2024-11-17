<template>
    <nav>
      <div class="nav-logo">
        <h1>Find You're Pet, go!</h1>
      </div>
      <ul>
        <li><router-link to="/">Inicio</router-link></li>
        <li><router-link to="/servicios">Servicios</router-link></li>
        <li><router-link to="/noticias">Noticias</router-link></li>
        <li><router-link to="/ayuda">Servicio de Ayuda</router-link></li>
        <li><router-link to="/sobre-nosotros">Sobre Nosotros</router-link></li>
      </ul>
      <div class="auth-buttons">
        <router-link to="/registro"><button class="register-btn">Registrarse</button></router-link>
        <router-link to="/iniciar-sesion"><button class="login-btn">Iniciar Sesión</button></router-link>
      </div>
    </nav>
  </template>

  <style scoped>
  nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem 2rem;
    background: linear-gradient(90deg, #0078d4, #00c8ff);
    color: white;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  }
  
  .nav-logo h1 {
    color: #ffffff;
    font-size: 1.5rem;
  }
  
  ul {
    list-style-type: none;
    display: flex;
    gap: 1.5rem;
    margin: 0;
    padding: 0;
  }
  
  ul li a {
    color: #ffffff;
    text-decoration: none;
    font-weight: bold;
    font-size: 1.1rem;
    transition: color 0.3s ease;
  }
  
  ul li a:hover {
    color: #a8e6ff;
  }
  
  .auth-buttons {
    display: flex;
    gap: 1rem;
  }
  
  .auth-buttons button {
    padding: 0.5rem 1rem;
    border: none;
    border-radius: 5px;
    font-weight: bold;
    cursor: pointer;
    transition: background 0.3s ease, color 0.3s ease;
  }
  
  .register-btn {
    background-color: #00a8e8;
    color: white;
  }
  
  .register-btn:hover {
    background-color: #00c8ff;
    color: #003354;
  }
  
  .login-btn {
    background-color: #0078d4;
    color: white;
  }
  
  .login-btn:hover {
    background-color: #005bb5;
    color: #d6e4ff;
  }
  </style>
  