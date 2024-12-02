<template>
  <div>
    <!-- Contenedor de la galería -->
    <div class="gallery">
      <div v-for="image in images" :key="image.id" class="gallery-item">
        <img :src="image.photo" :alt="'Image for post ' + image.post" />
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  props: {
    postId: {
      type: Number,
      required: true, // Se pasa como prop para filtrar por post específico
    },
  },
  data() {
    return {
      idperro: null,
      images: [], // Lista de imágenes
    };
  },
  methods: {  
    async fetchImages() {
      try {
        const response = await axios.get(`http://localhost:8080/post/lost-pets/${idperro}/photos/`);
        this.images = response.data; // Guarda las imágenes obtenidas del servidor
      } catch (error) {
        console.error(error);
        alert('Error fetching images');
      }
    },
  },
  mounted() {
    this.fetchImages(); // Carga las imágenes cuando el componente se monta
  },
};
</script>

<style>
/* Estilo básico para la galería */
.gallery {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.gallery-item {
  flex: 1 1 calc(25% - 10px); /* Cuatro columnas con espacio */
  box-sizing: border-box;
}

.gallery-item img {
  width: 100%;
  height: auto;
  border-radius: 5px;
  object-fit: cover;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}
</style>
