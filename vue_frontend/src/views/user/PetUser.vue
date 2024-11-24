<template>
    <div class="pets-page">
      <h1>Encuentra tu Mascota</h1>
      <div class="pets-container">
        <div class="pet-card" v-for="pet in pets" :key="pet.id">
          <h3>{{ pet.name }}</h3>
          <img :src="require(`@/assets/${pet.photo}`)" alt="Mascota" class="pet-photo" />
          <p class="pet-status" :class="pet.status">{{ pet.status }}</p>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        pets: [
          { id: 1, name: "Rex", photo: "dog1.png", status: "Encontrado" },
          { id: 2, name: "Luna", photo: "dog2.png", status: "Buscado" },
          { id: 3, name: "Max", photo: "dog3.png", status: "Encontrado" },
          { id: 4, name: "Falcon", photo: "dog4.png", status: "Encontrado" },
          { id: 5, name: "Jhuli", photo: "dog5.png", status: "Buscado" },
          { id: 6, name: "Scott", photo: "dog6.png", status: "Encontrado" },
          { id: 7, name: "Milaneso", photo: "dog7.png", status: "Encontrado" },
          { id: 8, name: "Mopri", photo: "dog8.png", status: "Encontrado" },
          { id: 9, name: "Nec", photo: "dog9.png", status: "Buscado" },
          { id: 10, name: "Princesa", photo: "dog10.png", status: "Encontrado" },
        ],
      };
    },
  };
  </script>
  
  <style scoped>
  .pets-page {
    padding: 2rem;
  }
  
  h1 {
    text-align: center;
    color: #4A90E2;
  }
  
  .pets-container {
    display: flex;
    flex-wrap: wrap;
    gap: 1rem;
    justify-content: center;
  }
  
  .pet-card {
    width: 200px;
    padding: 1rem;
    border: 1px solid #e1e1e1;
    border-radius: 8px;
    background-color: #f9f9f9;
    text-align: center;
  }
  
  .pet-photo {
    width: 100%;
    height: 150px;
    object-fit: cover;
    margin-bottom: 1rem;
  }
  
  .pet-status {
    font-weight: bold;
    padding: 0.5rem;
    border-radius: 5px;
  }
  
  .pet-status.Buscado {
    background-color: #FFB300;
    color: white;
  }
  
  .pet-status.Encontrado {
    background-color: #4CAF50;
    color: white;
  }
  </style>
  