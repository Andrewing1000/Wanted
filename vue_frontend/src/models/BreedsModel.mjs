import axios from "axios";

const API_BASE_URL = "http://localhost:8080/post/breeds/";

export const getBreeds = async () => {
  const response = await axios.get(API_BASE_URL);
  return response.data; // Retorna una lista de razas
};

export const createBreed = async (breed) => {
  const response = await axios.post(API_BASE_URL, breed);
  return response.data; // Retorna la raza creada
};

export const updateBreed = async (id, breed) => {
  const response = await axios.put(`${API_BASE_URL}${id}/`, breed);
  return response.data; // Retorna la raza actualizada
};

export const deleteBreed = async (id) => {
  const response = await axios.delete(`${API_BASE_URL}${id}/`);
  return response.data; // Retorna la confirmación de eliminación
};
