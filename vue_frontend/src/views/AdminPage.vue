<template>
    <div>

        
  
      <main>
        <div class="admin-section">
          <div class="admin-table-container">
            <table class="admin-table">
              <thead>
                <tr>
                  <th>Nombre</th>
                  <th>Apellido Completo</th>
                  <th>Rol</th>
                  <th>Estado</th>
                  <th>Acciones</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="user in users" :key="user.id">
                  <td>{{ user.name }}</td>
                  <td>{{ user.surname }}</td>
                  <td>
                    <span :class="user.role === 'Activo' ? 'status-active' : 'status-inactive'">
                      {{ user.role }}
                    </span>
                  </td>
                  <td>
                    <span :class="user.status === 'Activo' ? 'status-active' : 'status-inactive'">
                      {{ user.status }}
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
  export default {
    data() {
      return {
        isMenuActive: false,
        users: [
          { id: 1, name: "Hector Hugo", surname: "Campos", role: "Activo", status: "Activo" },
          { id: 2, name: "Fernando", surname: "Hernandez", role: "Activo", status: "Activo" },
          { id: 3, name: "Francisco", surname: "González", role: "Inactivo", status: "Activo" },
        ],
      };
    },
    methods: {
      toggleMenu() {
        this.isMenuActive = !this.isMenuActive;
      },
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