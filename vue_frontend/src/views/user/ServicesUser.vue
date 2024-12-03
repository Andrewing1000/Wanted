<template>
    <div class="services-page">
      <h1>Nuestros Servicios</h1>
      <div class="services-container">
        <div class="service-card" v-for="service in services" :key="service.id">
          <img :src="require(`@/assets/${service.photo}`)" alt="Service Image" class="service-photo" />
          <h3>{{ service.name }}</h3>
          <p>{{ service.description }}</p>
        </div>
      </div>
  
      <div class="slider">
        <div class="slider-item" v-for="option in options" :key="option.id">
          <p>{{ option.name }}</p>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        services: [
          { id: 1, name: "Publicación de Mascotas", description: "Publica tus mascotas perdidas de forma gratuita.", photo: "service1.jpg" },
          { id: 2, name: "Alertas de Avistamientos", description: "Recibe notificaciones de avistamientos en tiempo real.", photo: "service2.jpg" },
          { id: 3, name: "Colaboración con Refugios", description: "Trabajamos con refugios cercanos para ayudar a encontrar a tu mascota.", photo: "service3.jpg" },
          { id: 4, name: "Asistencia Veterinaria", description: "Obtén información sobre veterinarios cercanos y servicios de emergencia.", photo: "service4.jpg" },
          { id: 5, name: "Soporte Comunitario", description: "Conéctate con voluntarios y otros dueños de mascotas.", photo: "service5.jpg" },
          { id: 6, name: "Consejos de Seguridad", description: "Recibe consejos útiles para evitar que tus mascotas se pierdan.", photo: "service6.jpg" },
        ],
        options: [
          { id: 1, name: "App Móvil" },
          { id: 2, name: "Comunidad" },
        ],
      };
    },
  };
  </script>
  
  <style scoped>
  .services-page {
    padding: 2rem;
  }
  
  h1 {
    text-align: center;
    color: #4A90E2;
  }
  
  .services-container {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1rem;
    margin-bottom: 2rem;
  }
  
  .service-card {
    padding: 1rem;
    border: 1px solid #e1e1e1;
    border-radius: 8px;
    background-color: #f9f9f9;
    text-align: center;
  }
  
  .service-photo {
    width: 100%;
    height: 150px;
    object-fit: cover;
    margin-bottom: 1rem;
    border-radius: 8px;
  }
  
  .slider {
    display: flex;
    gap: 1rem;
    justify-content: center;
  }
  
  .slider-item {
    padding: 0.5rem;
    background-color: #4A90E2;
    color: white;
    border-radius: 5px;
    cursor: pointer;
  }
  
  .slider-item:hover {
    background-color: #357ABD;
  }
  </style>
  