<template>
    <div class="home-page">
      <section class="hero">
        <h1>Mapa de Avistamientos</h1>
        <p>Señala avistamientos de mascotas en el mapa para ayudar a ubicarlas.</p>
      </section>
  
      <section class="about">
        <h2>Mapa Interactivo</h2>
        <div id="map-container"></div>
      </section>
  
      <section class="featured-services">
        <h2>¿Cómo Funciona?</h2>
        <ul>
          <li>📍 Haz clic en el mapa para agregar un avistamiento.</li>
          <li>🔗 Comparte el enlace con la comunidad.</li>
          <li>📡 Mantente actualizado con las notificaciones.</li>
        </ul>
      </section>
    </div>
  </template>
  
  <script>
  export default {
    mounted() {
      // Inicializar el mapa (puedes usar Leaflet o Google Maps aquí)
    },
  };
  </script>
  
  <style scoped>
  #map-container {
    height: 400px;
    border: 1px solid #ddd;
    border-radius: 8px;
  }
  </style>
  