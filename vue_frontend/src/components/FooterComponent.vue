<template>
    <footer>
      <div class="footer-content">
        <div class="logo">Mi Logo</div>
        <div class="social-media">
          <a href="https://facebook.com" target="_blank">Facebook</a>
          <a href="https://twitter.com" target="_blank">Twitter</a>
          <a href="https://instagram.com" target="_blank">Instagram</a>
        </div>
      </div>
      <div class="footer-bottom">
        © 2024 Mi Institución. Todos los derechos reservados.
      </div>
    </footer>
  </template>
  
  <style scoped>
  footer {
    background-color: #1e1e1e;
    color: #e0e0e0;
    padding: 1.5rem 1rem;
    text-align: center;
    font-family: Arial, sans-serif;
  }
  
  .footer-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.5rem;
    border-bottom: 1px solid #444;
    padding-bottom: 1rem;
  }
  
  .logo {
    font-size: 1.2rem;
    font-weight: bold;
    color: #00b0ff; /* Color celeste para destacar el logo */
  }
  
  .social-media a {
    margin-right: 1rem;
    color: #e0e0e0;
    text-decoration: none;
    transition: color 0.3s;
  }
  
  .social-media a:hover {
    color: #00b0ff; /* Color celeste para los links al hacer hover */
  }
  
  .footer-bottom {
    font-size: 0.85rem;
    color: #888;
    margin-top: 1rem;
  }
  </style>
  