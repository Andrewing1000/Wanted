<template>
  <div>
    <input type="file" @change="onFileChange" />
    <button @click="uploadImage">Upload Image</button>
  </div>
</template>

<script>
import axios from 'axios';
const tokenU = localStorage.getItem("UserToken");

export default {
  props: {
    postId: {
      type: Number,
      required: true, // Se pasa como prop para reemplazar {id}
    },
  },
  data() {
    return {
      file: null, // Archivo seleccionado
    };
  },
  methods: {
    onFileChange(event) {
      this.file = event.target.files[0]; // Guarda el archivo seleccionado
    },
    async uploadImage() {
      if (!this.file) {
        alert("Please select a file!");
        return;
      }

      const formData = new FormData();
      formData.append('photo', this.file); // Adjunta el archivo
      formData.append('post', 1); // Incluye el ID del post

      try {
        const response = await axios.post(
          `http://localhost:8080/post/pet-sightings/${5}/photos/upload/`,
          formData,
          {
            headers: {
              'Authorization': 'Token ' + tokenU,
            },
          }
        );
        console.log(response.data);
        alert('Image uploaded successfully!');
      } catch (error) {
        console.error(error);
        alert('Error uploading image');
      }
    },
  },
};
</script>
