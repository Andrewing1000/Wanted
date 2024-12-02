<template>
    <div class="pets-page">
      <h1>Encuentra tu Mascota</h1>
      <div class="pets-container">
        <div class="pet-card" v-for="pet in pets" :key="pet.id">
          <h3>{{ pet.pet_name }}</h3>
          <!-- imagen perro -->
          <p class="pet-status" :class="pet.status">{{ pet.reward_amount }}</p>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  let url = 'http://localhost:8080'
  const tokenU = localStorage.getItem("UserToken");
  let config = {
      headers: {
          Authorization: 'Token ' + tokenU,
      }
  }
  export default {
  methods: {
    begin(){
      axios.get(url+'/post/lost-pets/',config).then((response) => {
          this.pets = response.data;
          console.log(this.pets);
          
      });
    },
  },
  created () {
    this.begin()
  },
    data() {
      return {
        pets: [],
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
  