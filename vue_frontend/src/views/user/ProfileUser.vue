<template>
    <div class="profile-page">
      <h1>Editar Perfil</h1>
      <div class="profile-header">
        <img :src="user.profilePhoto" alt="Foto de Perfil" class="profile-photo" />
        <button @click="changePhoto" class="change-photo-btn">Cambiar Foto</button>
      </div>
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
            v-model="user.phone" 
            placeholder="Ingrese su número de teléfono" 
            required
          />
        </div>
        <div class="form-group">
          <label for="address">Dirección</label>
          <input 
            type="text" 
            id="address" 
            v-model="user.address" 
            placeholder="Ingrese su dirección completa" 
          />
        </div>
        <div class="form-group">
          <label for="birthdate">Fecha de Nacimiento</label>
          <input 
            type="date" 
            id="birthdate" 
            v-model="user.birthdate" 
            required
          />
        </div>
        <div class="form-group">
          <label for="bio">Biografía</label>
          <textarea 
            id="bio" 
            v-model="user.bio" 
            placeholder="Escribe algo sobre ti" 
            rows="3"
          ></textarea>
        </div>
        <button type="submit">Guardar Cambios</button>
      </form>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        user: {
          name: "Juan Pérez",
          email: "juan.perez@example.com",
          phone: "123-456-7890",
          address: "Av. Siempre Viva 742",
          birthdate: "1990-01-01",
          bio: "Amante de los animales y defensor de los derechos de las mascotas.",
          profilePhoto: require('@/assets/profile.jpg'), // Foto usando require
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
  