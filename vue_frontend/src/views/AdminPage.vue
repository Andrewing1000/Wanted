<template>
    <div>

        
  
      <main>
        <div class="admin-section">
          <div class="admin-table-container">
            <table class="admin-table">
              <thead>
                <tr>
                  <th>Nombre</th>
                  <th>Numero</th>
                  <th>Correo</th>
                  <th>Rol</th>
                  <th>Estado</th>
                  <th>Acciones</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="user in users" :key="user.id">
                  <td>{{ user.name }}</td>
                  <td>{{ user.phone_number }}</td>
                  <td>{{ user.phone_number }}</td>
                  <td>
                    <span :class="user.is_staff === 'Activo' ? 'status-inactive' : 'status-active'">
                      {{ user.role }}
                    </span>
                  </td>
                  <td>
                    <span :class="user.is_active === 'Activo' ? 'status-active' : 'status-inactive'">
                      {{ user.is_active }}
                    </span>
                  </td>
                  <td>
                    <i class="action-icon">👁️</i>
                    <i class="action-icon">✏️</i>
                    <i class="action-icon">🗑️</i>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </main>
  

    </div>
  </template>
  
  <script>
  import axios from 'axios';
  export default {
  created () {
    let url = 'http://localhost:8080'
    
    const tokenU = localStorage.getItem("UserToken");
    let config = {
        headers: {
            Authorization: 'Token ' + tokenU,
        }
    }

    axios.get(url+'/user/list/',config).then((response) => {
        this.users = response.data;
        console.log(this.users);
        
    });
  },
    data() {
      return {
        isMenuActive: false,
        users: [],
      };
    },
    methods: {
      toggleMenu() {
        this.isMenuActive = !this.isMenuActive;
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
</style>