<template>
    <div class="services-page">
      <section class="hero">
        <h1>Nuestros Servicios</h1>
        <p>Ayudamos a los dueños a reunirse con sus mascotas a través de nuestros servicios especializados.</p>
      </section>
  
      <section class="services-list">
        <h2>Servicios Ofrecidos</h2>
        <ul>
          <li>📄 <strong>Creación de reportes de mascotas perdidas</strong>: Permite a los dueños reportar la desaparición de sus mascotas y recibir apoyo de la comunidad.</li>
          <li>🗺️ <strong>Mapa de avistamientos recientes</strong>: Consulta nuestro mapa interactivo para ver dónde se han reportado avistamientos de mascotas.</li>
          <li>🏠 <strong>Asistencia con refugios de animales</strong>: Colaboramos con refugios locales para ayudar a encontrar hogares para mascotas perdidas.</li>
          <li>📧 <strong>Notificaciones de avistamientos</strong>: Recibe alertas personalizadas cuando se reporten avistamientos de mascotas en tu área.</li>
          <li>💬 <strong>Asesoría y recursos</strong>: Proporcionamos guías y consejos sobre cómo buscar a tu mascota y mantenerla segura.</li>
        </ul>
      </section>
  
      <section class="testimonial">
        <h2>Historias de Éxito</h2>
        <div class="testimonial-item">
          <p>“El servicio de creación de reportes fue muy fácil de usar. Gracias a eso, recuperé a mi perro en menos de una semana.”</p>
          <span>- Ana López</span>
        </div>
        <div class="testimonial-item">
          <p>“El mapa de avistamientos me ayudó a encontrar a mi gato cuando alguien lo vio en el vecindario. ¡Increíble trabajo!”</p>
          <span>- Roberto Pérez</span>
        </div>
      </section>
    </div>
  </template>
  
  <style scoped>
  .services-page {
    font-family: Arial, sans-serif;
    color: #333;
    margin: 0 auto;
    padding: 2rem;
    max-width: 800px;
  }
  
  .hero {
    text-align: center;
    background-color: #4A90E2;
    color: #fff;
    padding: 3rem 1rem;
    border-radius: 8px;
  }
  
  .hero h1 {
    font-size: 2.5rem;
    margin-bottom: 0.5rem;
  }
  
  .hero p {
    font-size: 1.2rem;
    margin-bottom: 1rem;
  }
  
  .services-list {
    margin: 2rem 0;
    padding: 1rem;
    border: 1px solid #e1e1e1;
    border-radius: 8px;
    background-color: #f9f9f9;
  }
  
  h2 {
    color: #4A90E2;
    font-size: 1.8rem;
    margin-bottom: 0.5rem;
  }
  
  p, li {
    font-size: 1rem;
    line-height: 1.6;
  }
  
  .services-list ul {
    list-style-type: none;
    padding: 0;
  }
  
  .services-list li {
    padding: 0.5rem 0;
  }
  
  .testimonial {
    margin-top: 2rem;
    padding: 1rem;
    border: 1px solid #e1e1e1;
    border-radius: 8px;
    background-color: #f9f9f9;
  }
  
  .testimonial-item {
    margin-top: 1rem;
    font-style: italic;
    color: #555;
  }
  
  .testimonial-item span {
    display: block;
    margin-top: 0.5rem;
    font-weight: bold;
    color: #4A90E2;
  }
  </style>
  