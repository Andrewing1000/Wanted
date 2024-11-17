<template>
    <div class="home-page">
      <section class="hero">
        <h1>Bienvenido a Mascotas Perdidas</h1>
        <p>Conectando familias con sus mascotas perdidas de manera rápida y segura.</p>
        <button class="cta-button">Ver Mascotas Perdidas</button>
      </section>
      
      <section class="about">
        <h2>¿Quiénes somos?</h2>
        <p>Somos una institución dedicada a reunir mascotas perdidas con sus seres queridos. A través de la colaboración de la comunidad y el apoyo de refugios locales, trabajamos para garantizar que cada mascota tenga la oportunidad de regresar a casa.</p>
      </section>
  
      <section class="featured-services">
        <h2>Nuestros Servicios</h2>
        <ul>
          <li>📌 Publicación de reportes de mascotas perdidas</li>
          <li>🏠 Colaboración con refugios y veterinarias</li>
          <li>📍 Notificaciones de avistamientos en tiempo real</li>
          <li>📲 Notificaciones y alertas personalizadas</li>
        </ul>
      </section>
  
      <section class="testimonial">
        <h2>Historias de Reencuentro</h2>
        <div class="testimonial-item">
          <p>“Gracias a Mascotas Perdidas, pudimos encontrar a nuestra perrita en solo 3 días. La comunidad fue de gran ayuda, y no podríamos estar más agradecidos.”</p>
          <span>- Familia Martínez</span>
        </div>
        <div class="testimonial-item">
          <p>“Recibimos una notificación de avistamiento y encontramos a nuestro gato en un refugio local. Este servicio es invaluable.”</p>
          <span>- Carlos Gómez</span>
        </div>
      </section>
    </div>
  </template>
  
  <style scoped>
  .home-page {
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
  
  .cta-button {
    background-color: #fff;
    color: #4A90E2;
    padding: 0.8rem 1.5rem;
    border: none;
    border-radius: 5px;
    font-weight: bold;
    cursor: pointer;
    transition: background-color 0.3s;
  }
  
  .cta-button:hover {
    background-color: #e1e1e1;
  }
  
  .about, .featured-services, .testimonial {
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
  
  .featured-services ul {
    list-style-type: none;
    padding: 0;
  }
  
  .featured-services li {
    padding: 0.5rem 0;
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
  