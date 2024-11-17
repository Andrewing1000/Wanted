<template>
    <div class="register-page">
      <h1>Registrarse</h1>
      <p>Únete a nuestra comunidad y ayúdanos a encontrar mascotas perdidas. Completa el siguiente formulario para crear tu cuenta.</p>
      
      <form @submit.prevent="handleSubmit">
        <div class="form-group">
          <label for="name">Nombre Completo:</label>
          <input type="text" id="name" v-model="name" required />
        </div>
  
        <div class="form-group">
          <label for="email">Correo Electrónico:</label>
          <input type="email" id="email" v-model="email" required />
        </div>
  
        <div class="form-group">
          <label for="password">Contraseña:</label>
          <input type="password" id="password" v-model="password" required />
        </div>
  
        <div class="form-group">
          <label for="confirm-password">Confirmar Contraseña:</label>
          <input type="password" id="confirm-password" v-model="confirmPassword" required />
        </div>
  
        <button type="submit">Registrarse</button>
      </form>
  
      <p>¿Ya tienes una cuenta? <router-link to="/login">Iniciar Sesión</router-link></p>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        name: '',
        email: '',
        password: '',
        confirmPassword: ''
      };
    },
    methods: {
      handleSubmit() {
        // Lógica para manejar el registro
        alert(`Usuario registrado: ${this.name}`);
        // Aquí puedes agregar más lógica, como enviar los datos a un servidor
      }
    }
  };
  </script>
  
  <style scoped>
  .register-page {
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
  