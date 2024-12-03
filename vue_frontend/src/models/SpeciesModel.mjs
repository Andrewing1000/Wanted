import axios from "axios";

const API_BASE_URL = "http://localhost:8080/post/species/";

export const getSpecies = async () => {
  const response = await axios.get(API_BASE_URL);
  return response.data; // Retorna una lista de especies
};

export const createSpecies = async (species) => {
  const response = await axios.post(API_BASE_URL, species);
  return response.data; // Retorna la especie creada
};

export const updateSpecies = async (id, species) => {
  const response = await axios.put(`${API_BASE_URL}${id}/`, species);
  return response.data; // Retorna la especie actualizada
};

export const deleteSpecies = async (id) => {
  const response = await axios.delete(`${API_BASE_URL}${id}/`);
  return response.data; // Retorna la confirmación de eliminación
};
