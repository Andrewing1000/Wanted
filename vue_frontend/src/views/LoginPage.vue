<template>
    <div class="login-page">
      <h1>Iniciar Sesión</h1>
      <p>Bienvenido de nuevo. Por favor, ingresa tus credenciales para acceder a tu cuenta.</p>
      
      <form @submit.prevent="handleLogin">
        <div class="form-group">
          <label for="email">Correo Electrónico:</label>
          <input type="email" id="email" v-model="email" required />
        </div>
  
        <div class="form-group">
          <label for="password">Contraseña:</label>
          <input type="password" id="password" v-model="password" required />
        </div>
  
        <button type="submit">Iniciar Sesión</button>
      </form>
  
      <p>¿No tienes una cuenta? <router-link to="/register">Registrarse</router-link></p>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        email: '',
        password: ''
      };
    },
    methods: {
      handleLogin() {
        // Lógica para manejar el inicio de sesión
        alert(`Inicio de sesión exitoso para: ${this.email}`);
        // Aquí puedes agregar más lógica, como verificar las credenciales
      }
    }
  };
  </script>
  
  <style scoped>
  .login-page {
    max-width: 600px;
    margin: 0 auto;
    padding: 2rem;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    background-color: #f9f9f9;
  }
  
  h1 {
    color: #007BFF;
  }
  
  .form-group {
    margin-bottom: 1.5rem;
  }
  
  label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: bold;
  }
  
  input {
    width: 100%;
    padding: 0.5rem;
    border: 1px solid #007BFF;
    border-radius: 4px;
  }
  
  button {
    background-color: #007BFF;
    color: white;
    padding: 0.7rem;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }
  
  button:hover {
    background-color: #0056b3;
  }
  
  p {
    margin-top: 1rem;
  }
  </style>
  