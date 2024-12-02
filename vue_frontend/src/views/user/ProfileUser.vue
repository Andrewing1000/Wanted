<template>
    <div class="profile-page">
      <h1>Editar Perfil</h1>
      <form @submit.prevent="saveProfile">
        <div class="form-group">
          <label for="name">Nombre</label>
          <input 
            type="text" 
            id="name" 
            v-model="user.name" 
            placeholder="Ingrese su nombre completo" 
            required
          />
        </div>
        <div class="form-group">
          <label for="email">Correo Electrónico</label>
          <input 
            type="email" 
            id="email" 
            v-model="user.email" 
            placeholder="Ingrese su correo electrónico" 
            required
          />
        </div>
        <div class="form-group">
          <label for="phone">Teléfono</label>
          <input 
            type="text" 
            id="phone" 
            v-model="user.phone_number" 
            placeholder="Ingrese su número de teléfono" 
            required
          />
        </div>
        <button type="submit">Guardar Cambios</button>
      </form>
    </div>
  </template>
  
  <script>
  import axios from "axios";

  const url = "http://localhost:8080";
  const tokenU = localStorage.getItem("UserToken");

  const config = {
    headers: {
      Authorization: "Token " + tokenU,
    },
  };
  export default {
  created () {
    this.begin();
  },
    data() {
      return {
        user: {
          name: '',
          email: '',
          phone_number: '',
          is_active: '',
          is_staff: '',
        },
      };
    },
    methods: {
      saveProfile() {
        console.log("Perfil actualizado:", this.user);
      },
      changePhoto() {
        alert("Funcionalidad para cambiar foto aún no implementada.");
      },
      begin(){
        axios.get(url+'/user/me/',config).then((response) => {
            this.user = response.data;
            console.log(this.user);
            
        });
      },
    },
  };
  </script>
  
  <style scoped>
  .profile-page {
    padding: 2rem;
    max-width: 600px;
    margin: 0 auto;
    background-color: #f9f9f9;
    border: 1px solid #e1e1e1;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
  
  h1 {
    text-align: center;
    color: #4A90E2;
    margin-bottom: 1.5rem;
  }
  
  .profile-header {
    display: flex;
    flex-direction: column;
    align-items: center; /* Centra los elementos horizontalmente */
    margin-bottom: 2rem;
  }
  
  .profile-photo {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid #4A90E2;
    margin-bottom: 1rem;
  }
  
  .change-photo-btn {
    background-color: #4A90E2;
    color: white;
    border: none;
    padding: 0.5rem 1rem;
    border-radius: 5px;
    font-weight: bold;
    cursor: pointer;
    text-transform: uppercase;
    transition: background-color 0.3s ease;
  }
  
  .change-photo-btn:hover {
    background-color: #357ABD;
  }
  
  form {
    display: flex;
    flex-direction: column;
    gap: 1.2rem;
  }
  
  .form-group {
    display: flex;
    flex-direction: column;
  }
  
  label {
    font-weight: bold;
    margin-bottom: 0.5rem;
    color: #333;
  }
  
  input, textarea {
    padding: 0.8rem;
    border: 1px solid #ddd;
    border-radius: 5px;
    font-size: 1rem;
  }
  
  input:focus, textarea:focus {
    border-color: #4A90E2;
    outline: none;
  }
  
  button {
    background-color: #4A90E2;
    color: white;
    padding: 0.8rem;
    border: none;
    border-radius: 5px;
    font-weight: bold;
    cursor: pointer;
    text-transform: uppercase;
    transition: background-color 0.3s ease;
  }
  
  button:hover {
    background-color: #357ABD;
  }
  
  button:focus {
    outline: none;
  }
  </style>
  