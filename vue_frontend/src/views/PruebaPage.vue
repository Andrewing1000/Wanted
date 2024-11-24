<template>
    <div class="default-page">
      <header>
        <h1>Bienvenido a Vue.js</h1>
        <p>Esta es tu página por defecto.</p>
      </header>
    </div>
  </template>
  <script>
  import "@/models/PruebaModel.mjs";
  export default {
    name: "DefaultPage",
    data() {
      return {
        year: new Date().getFullYear(),
      };
    },
    methods: {
      handleClick() {
        alert("¡Botón clicado!");
      },
    },
  };
  </script>
  
  <style scoped>
  .default-page {
    text-align: center;
    font-family: Arial, sans-serif;
    padding: 20px;
  }
  
  header {
    background-color: #42b883;
    color: white;
    padding: 10px 0;
  }
  
  footer {
    margin-top: 20px;
    color: #aaa;
  }
  </style>
  