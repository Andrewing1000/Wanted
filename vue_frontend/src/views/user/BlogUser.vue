<template>
  <div class="container">
    <h1 class="page-title">Registrar Pérdida de Mascota</h1>

    <!-- Formulario para enviar datos de la mascota perdida -->
    <form @submit.prevent="submitPetLost" class="form-container">
      <div class="form-group">
        <label for="pet_name">Nombre de la mascota</label>
        <input type="text" v-model="petLost.pet_name" id="pet_name" placeholder="Nombre de la mascota" required />
      </div>
      <div class="form-group">
        <label for="species">Especie</label>
        <input type="number" v-model="petLost.species" id="species" placeholder="Especie" required />
      </div>
      <div class="form-group">
        <label for="breed">Raza</label>
        <input type="number" v-model="petLost.breed" id="breed" placeholder="Raza" required />
      </div>
      <div class="form-group">
        <label for="color">Color</label>
        <input type="text" v-model="petLost.color" id="color" placeholder="Color" required />
      </div>
      <div class="form-group">
        <label for="description">Descripción</label>
        <textarea v-model="petLost.description" id="description" placeholder="Descripción de la mascota" required></textarea>
      </div>
      <div class="form-group">
        <label for="date_lost">Fecha de pérdida</label>
        <input type="date" v-model="petLost.date_lost" id="date_lost" required />
      </div>
      <div class="form-group">
        <label for="latitude">Latitud</label>
        <input type="number" v-model="petLost.latitude" id="latitude" placeholder="Latitud" step="any" required />
      </div>
      <div class="form-group">
        <label for="longitude">Longitud</label>
        <input type="number" v-model="petLost.longitude" id="longitude" placeholder="Longitud" step="any" required />
      </div>
      <div class="form-group">
        <label for="reward_amount">Recompensa</label>
        <input type="number" v-model="petLost.reward_amount" id="reward_amount" placeholder="Recompensa" step="any" required />
      </div>
      <button type="submit" class="submit-btn">Registrar pérdida</button>
    </form>

    <!-- Selección de archivo para cargar la imagen -->
    <div v-if="createdPetLostId" class="upload-container">
      <h2>Sube una imagen para la mascota perdida</h2>
      <input type="file" @change="onFileChange" class="file-input" />
      <button @click="uploadImage" class="upload-btn">Subir Imagen</button>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      petLost: {
        pet_name: "",
        species: 1,
        breed: 1,
        color: "",
        description: "",
        date_lost: "",
        latitude: "",
        longitude: "",
        reward_amount: "",
      },
      file: null,
      createdPetLostId: null,
    };
  },
  methods: {
    async submitPetLost() {
      try {
        const response = await axios.post("http://localhost:8080/post/lost-pets/", this.petLost, {
          headers: {
            "Authorization": "Token " + localStorage.getItem("UserToken"),
          },
        });

        this.createdPetLostId = response.data.id;
        alert("Pérdida registrada con éxito!");
      } catch (error) {
        console.error("Error registrando la pérdida", error);
        alert("Error al registrar la pérdida");
      }
    },

    onFileChange(event) {
      this.file = event.target.files[0];
    },

    async uploadImage() {
      if (!this.file) {
        alert("Por favor seleccione una imagen.");
        return;
      }

      const formData = new FormData();
      formData.append("photo", this.file);

      try {
        const response = await axios.post(
          `http://localhost:8080/post/lost-pets/${this.createdPetLostId}/photos/upload/`,
          formData,
          {
            headers: {
              "Authorization": "Token " + localStorage.getItem("UserToken"),
            },
          }
        );
        console.log(response);

        alert("Imagen subida con éxito!");
      } catch (error) {
        console.error("Error subiendo la imagen", error);
        alert("Error al subir la imagen");
      }
    },
  },
};
</script>

<style scoped>
/* Estilos generales */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: Arial, sans-serif;
}

body {
  background-color: #f7f7f7;
  padding: 2rem;
}

.container {
  max-width: 800px;
  margin: 0 auto;
  background-color: #ffffff;
  border-radius: 10px;
  box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
  padding: 2rem;
}

/* Estilos de título */
.page-title {
  text-align: center;
  color: #4a90e2;
  font-size: 2rem;
  margin-bottom: 2rem;
}

/* Estilos del formulario */
.form-container {
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

label {
  font-weight: bold;
  color: #333;
}

input,
textarea {
  padding: 0.8rem;
  border-radius: 8px;
  border: 1px solid #ddd;
  font-size: 1rem;
  color: #333;
}

textarea {
  resize: vertical;
  height: 150px;
}

button {
  padding: 0.8rem 1.2rem;
  border: none;
  background-color: #4a90e2;
  color: white;
  font-size: 1rem;
  cursor: pointer;
  border-radius: 5px;
  transition: background-color 0.3s;
}

button:hover {
  background-color: #357ab7;
}

/* Estilos para el upload */
.upload-container {
  margin-top: 2rem;
  text-align: center;
}

.file-input {
  margin-bottom: 1rem;
}

.upload-btn {
  padding: 0.8rem 1.2rem;
  border: none;
  background-color: #4caf50;
  color: white;
  font-size: 1rem;
  cursor: pointer;
  border-radius: 5px;
  transition: background-color 0.3s;
}

.upload-btn:hover {
  background-color: #45a049;
}
</style>
