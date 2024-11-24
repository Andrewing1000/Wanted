<template>
    <div class="app-container">
      <header id="header">
        <h1>Agregar Asignatura</h1>
      </header>
  
      <!-- Formulario para agregar una nueva asignatura -->
      <div class="form-container">
        <div class="input-group">
          <label for="nombre">Nombre de la Asignatura</label>
          <input
            v-model="nuevaAsignatura.nombre"
            id="nombre"
            placeholder="Nombre de la Asignatura"
            class="input-field"
          />
        </div>
  
        <div class="input-group">
          <label for="colegio">Seleccionar Colegio</label>
          <select v-model="nuevaAsignatura.colegio" class="input-field">
            <option
              v-for="colegio in colegios"
              :key="colegio.id"
              :value="colegio.id"
            >
              {{ colegio.nombre }}
            </option>
          </select>
        </div>
  
        <div class="input-group">
          <label for="grado">Seleccionar Grado</label>
          <select v-model="nuevaAsignatura.grado" class="input-field">
            <option v-for="grado in grados" :key="grado.id" :value="grado.id">
              {{ grado.grado }}
            </option>
          </select>
        </div>
  
        <button @click="agregarAsignatura" class="add-button">
          Agregar Asignatura
        </button>
      </div>
  
      <!-- Mensaje de éxito o error -->
      <div v-if="mensaje" class="mensaje">
        {{ mensaje }}
      </div>
    </div>
  </template>
  
  <script>
  import { AsignaturaModel } from "../models/PruebaModel";
  import { RequestHandler } from "../controller/RequestHandler";
  
  export default {
    data() {
      return {
        nuevaAsignatura: {
          nombre: "",
          grado: 0,
          colegio: 0,
        },
        colegios: [], // Lista de colegios para popular el listbox
        grados: [], // Lista de grados para popular el listbox
        mensaje: "", // Mensaje de éxito o error
        usuarioLogueado: null, // Datos del usuario logueado
      };
    },
    async mounted() {
      // Forzar login para debug
      const ojo = new RequestHandler();
      const loginResponse = await ojo.postRequest("user/token/", {
        email: "ojo@amdin.com",
        password: "123",
      });
  
      this.usuarioLogueado = loginResponse.data;
  
      // Cargar los colegios y grados
      await this.cargarColegios();
      await this.cargarGrados();
    },
    methods: {
      // Cargar todos los colegios
      async cargarColegios() {
        try {
          const asignaturaModel = new AsignaturaModel();
          this.colegios = await asignaturaModel.obtenerColegios(); // Obtiene la lista de colegios
        } catch (error) {
          console.error("Error al cargar los colegios:", error);
        }
      },
  
      // Cargar todos los grados
      async cargarGrados() {
        try {
          const asignaturaModel = new AsignaturaModel();
          this.grados = await asignaturaModel.obtenerGrados(); // Obtiene la lista de grados
        } catch (error) {
          console.error("Error al cargar los grados:", error);
        }
      },
  
      // Método para agregar una nueva asignatura
      async agregarAsignatura() {
        try {
          const asignaturaModel = new AsignaturaModel();
  
          // Crear la nueva asignatura
          await asignaturaModel.crearAsignatura(
            this.nuevaAsignatura.nombre,
            this.nuevaAsignatura.grado,
            this.nuevaAsignatura.colegio
          );
  
          // Mostrar mensaje de éxito
          this.mensaje = "Asignatura agregada exitosamente";
  
          // Limpiar el formulario
          this.nuevaAsignatura = {
            nombre: "",
            grado: 0,
            colegio: 0,
          };
        } catch (error) {
          this.mensaje = "Error al agregar asignatura. Intenta de nuevo.";
          console.error("Error al agregar asignatura:", error);
        }
      },
    },
  };
  </script>
  
  <style scoped>
  .app-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 20px;
    background-color: #f4f7f6;
    height: 45vh;
  }
  
  #header {
    background-color: #0073e6;
    color: white;
    padding: 10px;
    text-align: center;
    width: 100%;
    margin-bottom: 20px;
    border-radius: 8px;
  }
  
  h1 {
    margin: 0;
    font-size: 24px;
  }
  
  .form-container {
    background-color: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
    max-width: 400px;
    width: 100%;
  }
  
  .input-group {
    margin-bottom: 15px;
  }
  
  .input-field {
    width: 100%;
    padding: 10px;
    border-radius: 4px;
    border: 1px solid #ccc;
    font-size: 16px;
  }
  
  .add-button {
    width: 100%;
    padding: 12px;
    background-color: #0073e6;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s ease;
  }
  
  .add-button:hover {
    background-color: #005bb5;
  }
  
  .mensaje {
    margin-top: 20px;
    font-size: 18px;
    color: green;
  }
  </style>
  