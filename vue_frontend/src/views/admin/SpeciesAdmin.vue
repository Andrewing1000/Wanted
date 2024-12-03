<template>
    <div class="species-admin">
      <h1>Administrar Especies</h1>
  
      <!-- Formulario para agregar una nueva especie -->
      <form @submit.prevent="handleCreate">
        <input v-model="newSpecies" placeholder="Nueva especie" required />
        <button type="submit">Agregar Especie</button>
      </form>
  
      <!-- Listado de especies -->
      <ul>
        <li v-for="species in speciesList" :key="species.id">
          {{ species.value }}
          <button @click="handleEdit(species.id)">Editar</button>
          <button @click="handleDelete(species.id)">Eliminar</button>
        </li>
      </ul>
    </div>
  </template>
  
  <script>
  import {
    getSpecies,
    createSpecies,
    updateSpecies,
    deleteSpecies,
  } from "@/models/SpeciesModel.mjs";
  
  export default {
    data() {
      return {
        speciesList: [], // Lista de especies
        newSpecies: "", // Campo para nueva especie
      };
    },
    async created() {
      // Obtener las especies al cargar el componente
      this.speciesList = await getSpecies();
    },
    methods: {
      // Crear una nueva especie
      async handleCreate() {
        const createdSpecies = await createSpecies({ value: this.newSpecies });
        this.speciesList.push(createdSpecies); // Agregar la especie a la lista
        this.newSpecies = ""; // Limpiar el campo de entrada
      },
  
      // Editar una especie existente
      async handleEdit(id) {
        const newValue = prompt("Editar especie:"); // Mostrar cuadro de diálogo
        if (newValue) {
          const updatedSpecies = await updateSpecies(id, { value: newValue });
          this.speciesList = this.speciesList.map((species) =>
            species.id === id ? updatedSpecies : species
          ); // Actualizar la lista con la especie editada
        }
      },
  
      // Eliminar una especie existente
      async handleDelete(id) {
        await deleteSpecies(id); // Eliminar la especie
        this.speciesList = this.speciesList.filter((species) => species.id !== id); // Remover de la lista
      },
    },
  };
  </script>
  
  <style scoped>
  .species-admin {
    max-width: 600px;
    margin: 0 auto;
    padding: 1rem;
    font-family: Arial, sans-serif;
  }
  
  h1 {
    color: #007BFF;
    text-align: center;
  }
  
  form {
    margin-bottom: 1rem;
    display: flex;
    gap: 0.5rem;
  }
  
  input {
    flex: 1;
    padding: 0.5rem;
    border: 1px solid #007BFF;
    border-radius: 4px;
    font-size: 1rem;
  }
  
  button {
    padding: 0.5rem 1rem;
    background-color: #007BFF;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 1rem;
  }
  
  button:hover {
    background-color: #0056b3;
  }
  
  ul {
    list-style: none;
    padding: 0;
  }
  
  li {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.5rem 0;
    border-bottom: 1px solid #ddd;
  }
  
  li button {
    margin-left: 0.5rem;
    background-color: #ff4d4d;
  }
  
  li button:first-of-type {
    background-color: #ffa500;
  }
  
  li button:hover {
    opacity: 0.8;
  }
  </style>
  