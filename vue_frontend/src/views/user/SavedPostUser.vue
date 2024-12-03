<template>
    <div class="home-page">
      <section class="hero">
        <h1>Publicaciones Guardadas</h1>
        <p>Revisa las publicaciones que has guardado para referencia futura.</p>
      </section>
  
      <section class="about">
        <h2>Mascotas Guardadas</h2>
        <div class="cards-container">
          <div class="card" v-for="publication in savedPublications" :key="publication.id">
            <img :src="publication.photo" alt="Mascota" />
            <h2>{{ publication.name }}</h2>
          </div>
        </div>
      </section>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        savedPublications: [
          { id: 1, name: "Rex", photo: require('@/assets/dog1.png') },
          { id: 2, name: "Luna", photo: require('@/assets/dog2.png') },
        ],
      };
    },
  };
  </script>
  
  <style scoped>
  .cards-container {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 1.5rem;
  }
  .card {
    text-align: center;
    background-color: #fff;
    padding: 1rem;
    border: 1px solid #ddd;
    border-radius: 5px;
  }
  .card img {
    width: 100%;
    border-radius: 5px;
  }
  </style>
  