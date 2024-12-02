<template>
    <div class="blog-page">
      <h1>Historias de Reencuentro</h1>
      <div class="blog-container">
        <div class="blog-post" v-for="post in posts" :key="post.id">
          <h3>{{ post.title }}</h3>
          <p>{{ post.content }}</p>
          <button @click="toggleLike(post.id)">
            ❤️ {{ post.likes }}
          </button>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        posts: [
          { id: 1, title: "La historia de Rex", content: "Recibí una alerta y encontré a Rex en el refugio.", likes: 5 },
          { id: 2, title: "Luna volvió a casa", content: "Después de días buscando, Luna volvió gracias a una notificación de avistamiento.", likes: 8 },
          { id: 3, title: "Max aparecio", content: "Max Aparecio en Sopocachi :), gracias a Dios.", likes: 10 },
          { id: 4, title: "Falcon, un milagro", content: "Después de días buscandolo, Falcon aparecio por la ciudad El Alto.", likes: 20 },
          { id: 5, title: "Milaneso lo lograste", content: "Milaneso aperecio :,v soy tan feliz.", likes: 7 },
          { id: 6, title: "Mopri es afortunado", content: "Mopri no aparecia por casi 3 meses, al fin volvio despues de tanto tiempo :').", likes: 15 },
        ],
      };
    },
    methods: {
      toggleLike(postId) {
        const post = this.posts.find(p => p.id === postId);
        post.likes += 1;
      },
    },
  };
  </script>
  
  <style scoped>
  .blog-page {
    padding: 2rem;
  }
  
  h1 {
    text-align: center;
    color: #4A90E2;
  }
  
  .blog-container {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }
  
  .blog-post {
    padding: 1rem;
    border: 1px solid #e1e1e1;
    border-radius: 8px;
    background-color: #f9f9f9;
  }
  
  button {
    background-color: #fff;
    border: 1px solid #4A90E2;
    color: #4A90E2;
    padding: 0.5rem 1rem;
    border-radius: 5px;
    cursor: pointer;
  }
  
  button:hover {
    background-color: #4A90E2;
    color: white;
  }
  </style>
  