<template>
  <div class="pets-page">
    <h1>Mascotas perdidas</h1>
    <div class="pets-container">
      <div 
        class="pet-card" 
        v-for="pet in pets" 
        :key="pet.id" 
        @click="toggleCard(pet)"
      >
        <h3>{{ pet.pet_name }}</h3>
        <img v-if="pet.photo" :src="pet.photo" alt="Foto de mascota" class="pet-photo" />
        <p class="pet-status" :class="pet.status">Recompensa: {{ pet.reward_amount }} $</p>

        <!-- Descripción y Fecha de pérdida -->
        <p class="pet-description">{{ pet.description }}</p>
        <p class="pet-date-lost"><strong>Fecha de pérdida:</strong> {{ formatDate(pet.date_lost) }}</p>

        <!-- Enlace de Google Maps -->
        <div v-if="activePet && activePet.id === pet.id" class="map-card">
          <p>
            <a 
              :href="'https://www.google.com/maps?q=' + pet.latitude + ',' + pet.longitude" 
              target="_blank"
              class="map-link"
            >
              Ver ubicación en Google Maps
            </a>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

const baseUrl = "http://localhost:8080";
const tokenU = localStorage.getItem("UserToken");

const config = {
  headers: {
    Authorization: "Token " + tokenU,
  },
};

export default {
  methods: {
    async fetchPets() {
      try {
        const response = await axios.get(`${baseUrl}/post/lost-pets/`, config);
        const pets = response.data;

        const petsWithPhotos = await Promise.all(
          pets.map(async (pet) => {
            try {
              const photoResponse = await axios.get(
                `${baseUrl}/post/lost-pets/${pet.id}/photos/`,
                config
              );
              pet.photo = photoResponse.data.length > 0 ? photoResponse.data[0].photo : null;
            } catch (error) {
              console.error(`Error fetching photo for pet ${pet.id}`, error);
              pet.photo = null;
            }
            return pet;
          })
        );

        this.pets = petsWithPhotos;
      } catch (error) {
        console.error("Error fetching pets", error);
      }
    },
    toggleCard(pet) {
      this.activePet = this.activePet && this.activePet.id === pet.id ? null : pet;
    },
    formatDate(date) {
      const options = { year: 'numeric', month: 'long', day: 'numeric' };
      return new Date(date).toLocaleDateString('es-ES', options);
    },
  },
  created() {
    this.fetchPets();
  },
  data() {
    return {
      pets: [],
      activePet: null,
    };
  },
};
</script>

<style scoped>
.pets-page {
  padding: 2rem;
}

h1 {
  text-align: center;
  color: #4a90e2;
}

.pets-container {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  justify-content: center;
}

.pet-card {
  width: 240px;
  padding: 1rem;
  border: 1px solid #e1e1e1;
  border-radius: 8px;
  background-color: #f9f9f9;
  text-align: center;
  cursor: pointer;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease-in-out;
}

.pet-card:hover {
  transform: translateY(-5px);
}

.pet-photo {
  width: 100%;
  height: 150px;
  object-fit: cover;
  margin-bottom: 1rem;
  border-radius: 5px;
}

.pet-status {
  font-weight: bold;
  padding: 0.5rem;
  border-radius: 5px;
}

.pet-status.Buscado {
  background-color: #ffb300;
  color: white;
}

.pet-status.Encontrado {
  background-color: #4caf50;
  color: white;
}

.pet-description {
  font-size: 0.9rem;
  color: #555;
  margin-bottom: 0.5rem;
}

.pet-date-lost {
  font-size: 0.9rem;
  color: #777;
}

.map-card {
  margin-top: 1rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 0.5rem;
  background-color: #fff;
}

.map-link {
  color: #4a90e2;
  text-decoration: none;
  font-weight: bold;
}
</style>
