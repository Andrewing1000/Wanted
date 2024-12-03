<template>
    <div class="breeds-admin">
      <h1>Administrar Razas</h1>
  
      <!-- Formulario para crear una nueva raza -->
      <form @submit.prevent="handleCreate">
        <input v-model="newBreed" placeholder="Nueva raza" required />
        <button type="submit">Crear Raza</button>
      </form>
  
      <!-- Listado de razas -->
      <ul>
        <li v-for="breed in breedsList" :key="breed.id">
          {{ breed.value }}
          <button @click="handleEdit(breed.id)">Editar</button>
          <button @click="handleDelete(breed.id)">Eliminar</button>
        </li>
      </ul>
    </div>
  </template>
  
  <script>
  import {
    getBreeds,
    createBreed,
    updateBreed,
    deleteBreed,
  } from "@/models/BreedsModel.mjs";
  
  export default {
    data() {
      return {
        breedsList: [], // Lista de razas
        newBreed: "", // Campo para la nueva raza
      };
    },
    async created() {
      // Cargar las razas al montar el componente
      this.breedsList = await getBreeds();
    },
    methods: {
      // Crear una nueva raza
      async handleCreate() {
        const createdBreed = await createBreed({ value: this.newBreed });
        this.breedsList.push(createdBreed); // Agregar la nueva raza a la lista
        this.newBreed = ""; // Limpiar el campo de entrada
      },
  
      // Editar una raza existente
      async handleEdit(id) {
        const newValue = prompt("Editar raza:"); // Mostrar un cuadro de diálogo para editar
        if (newValue) {
          const updatedBreed = await updateBreed(id, { value: newValue });
          this.breedsList = this.breedsList.map((breed) =>
            breed.id === id ? updatedBreed : breed
          ); // Actualizar la lista con la raza modificada
        }
      },
  
      // Eliminar una raza existente
      async handleDelete(id) {
        await deleteBreed(id); // Llamar al modelo para eliminar
        this.breedsList = this.breedsList.filter((breed) => breed.id !== id); // Filtrar la lista
      },
    },
  };
  </script>
  
  <style scoped>
  .breeds-admin {
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
  