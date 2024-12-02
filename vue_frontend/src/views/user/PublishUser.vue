<template>
    <div class="home-page">
      <section class="hero">
        <h1>Publicar Mascota</h1>
        <p>Comparte información sobre una mascota perdida para ayudar a encontrarla.</p>
      </section>
  
      <section class="about">
        <h2>Formulario de Publicación</h2>
        <form @submit.prevent="submitForm">
          <div class="form-group">
            <label for="pet-name">Nombre de la Mascota</label>
            <input type="text" id="pet-name" v-model="formData.name" required />
          </div>
          <div class="form-group">
            <label for="pet-photo">Foto de la Mascota</label>
            <input type="file" id="pet-photo" @change="handlePhoto" />
          </div>
          <div class="form-group">
            <label for="pet-info">Información Adicional</label>
            <textarea id="pet-info" v-model="formData.info" rows="4"></textarea>
          </div>
          <button class="cta-button" type="submit">Publicar</button>
        </form>
      </section>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        formData: {
          name: "",
          info: "",
          photo: null,
        },
      };
    },
    methods: {
      handlePhoto(event) {
        this.formData.photo = event.target.files[0];
      },
      submitForm() {
        console.log("Publicando mascota:", this.formData);
      },
    },
  };
  </script>
  
  <style scoped>
  .publish-page {
    padding: 2rem;
    background-color: #f9f9f9;
  }
  h1 {
    text-align: center;
    color: #4A90E2;
  }
  .form-group {
    margin-bottom: 1.5rem;
  }
  input, textarea {
    width: 100%;
    padding: 0.8rem;
    border: 1px solid #ddd;
    border-radius: 5px;
  }
  button {
    background-color: #4A90E2;
    color: white;
    padding: 0.8rem;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
  </style>
  