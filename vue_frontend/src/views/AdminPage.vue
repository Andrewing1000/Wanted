<template>
    <div>

        
  
      <main>
        <div class="admin-section">
          <div class="admin-table-container">
            <button @click="mostrarFormulario = !mostrarFormulario, CreateF= true">
            Crear usuario
          </button>
            <table class="admin-table">
              <thead>
                <tr>
                  <th>Nombre</th>
                  <th>Numero</th>
                  <th>Correo</th>
                  <th>Rol</th>
                  <th>Estado</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="user in users" :key="user.id">
                  <td>{{ user.name }}</td>
                  <td>{{ user.phone_number }}</td>
                  <td>{{ user.email }}</td>
                  <td>
                    <span :class="user.is_staff ? 'status-active' : 'status-inactive'">
                      {{user.is_staff ? 'Admin' : 'Usuario' }}
                    </span>
                  </td>
                  <td>
                    <span :class="user.is_active ? 'status-active' : 'status-inactive'">
                      {{ user.is_active ? 'En linea' : 'Desconectado' }}
                    </span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <!-- Contenedor centrado para el formulario -->
        <div>
          

          <div class="overlay" v-if="mostrarFormulario">
            <div class="card">
              <form @submit.prevent="enviarFormulario">
                <label for="email">Nombre:</label>
                <input type="text" id="email" v-model="user1.name" required />
                <label for="email">Correo Electrónico:</label>
                <input type="email" id="email" v-model="user1.email" required />
                <label for="email">Numero:</label>
                <input type="number" id="email" v-model="user1.phone_number" required />
                <label for="email"  v-if="CreateF">Contraseña:</label>
                <input type="text" id="email" v-model="user1.password" required v-if="CreateF"/>
                <label for="opcion">Rol:</label>
                <select v-model="user1.is_staff" id="opcion">
                  <option :value="true">Admin</option>
                  <option :value="false">Usuario</option>
                </select>
                
                <button type="button" @click="mostrarFormulario = false, reset()">Cancelar</button>
                
                <button type="submit" v-if="CreateF" @click="crearUsuario()">Crear</button>
              </form>
            </div>
          </div>

        </div>
      </main>
  

    </div>
  </template>
  
  <script>
  import axios from 'axios';
  let url = 'http://localhost:8080'
  const tokenU = localStorage.getItem("UserToken");
    let config = {
        headers: {
            Authorization: 'Token ' + tokenU,
        }
    }
  export default {
  created () {
    
    this.begin();
  },
    data() {
      return {
        mostrarFormulario: false,
        CreateF: true,
        users: [],
        user1: {
          id: null,
          email: '',
          password: '',
          name: '',
          phone_number: '',
          is_active: true,
          is_staff: ''
        }
      };
    },
    methods: {
      begin(){
        axios.get(url+'/user/list/',config).then((response) => {
            this.users = response.data;
            console.log(this.users);
            
        });
      },
      crearUsuario() {
        axios.post(url+'/user/create/',this.user1,config).then(() => {
            this.begin();
            this.reset();
        });
      },
      reset(){
        this.user1= {
          id: null,
          email: '',
          password: '',
          name: '',
          phone_number: '',
          is_active: true,
          is_staff: ''
        }
      }
    },
  };
  </script>
  
  <style scoped>
/* Estilos mínimos necesarios para el componente */

/* Fondo y fuente global */
body {
  font-family: Arial, sans-serif;
  background-color: #f3edf7;
}

/* Tabla */
.admin-table-container {
  margin: 20px auto;
  width: 90%;
  overflow-x: auto;
}

.admin-table {
  width: 100%;
  border-collapse: collapse;
  background-color: #ffffff;
  text-align: left;
}

.admin-table th,
.admin-table td {
  padding: 10px;
  border: 1px solid #ccc;
}

.admin-table th {
  background-color: #8abad3;
  color: #fff;
  font-weight: bold;
}

.admin-table tr:nth-child(even) {
  background-color: #f9f9f9;
}

/* Estado del usuario */
.status-active {
  background-color: #0d6efd;
  color: #fff;
  padding: 5px 10px;
  border-radius: 5px;
}

.status-inactive {
  background-color: #dc3545;
  color: #fff;
  padding: 5px 10px;
  border-radius: 5px;
}

/* Íconos de acción */
.action-icon {
  cursor: pointer;
  margin: 0 5px;
  font-size: 1.2em;
}

.overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: rgba(0, 0, 0, 0.5); /* Fondo semitransparente */
  z-index: 1000;
}

.card {
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  padding: 20px;
  width: 300px;
  text-align: center;
}

button {
  margin-top: 10px;
  padding: 5px 10px;
  cursor: pointer;
  border: none;
  border-radius: 5px;
  background-color: #007bff;
  color: white;
}

button:hover {
  background-color: #0056b3;
}

form select {
  width: 100%;
  margin-bottom: 15px;
  padding: 8px;
  border-radius: 5px;
  border: 1px solid #ccc;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

p {
  margin-top: 15px;
  color: green;
  font-weight: bold;
} 
</style>