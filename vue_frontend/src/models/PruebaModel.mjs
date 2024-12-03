import axios from "axios";

let url = 'http://localhost:8080'

let admin={
  email: 'admin@example.com',
  password: 'admin'
}

let response = await axios.post(url+'/user/token/',admin)
let tokenS = response.data.token

console.log(tokenS);
  

let config = {
  headers: {
    Authorization: 'Token '+tokenS,
  }
}

/* let datos = {
  pet_name: "string",
  species: "string",
  breed: "string",
  color: "string",
  description: "string",
  photo: "string",
  date_lost: "2024-11-24",
  last_seen_location: "string",
  reward_amount: ""
} */

let xd = await axios.get(url+'/user/me/',config)



//axios.put(url+'/post/lost-pets/',datos,config)
// let xd2 = await axios.get(url+'/post/lost-pets/',config)//mostrar
// axios.post(url+'/post/lost-pets/'+id+'/',datos,config)//editar
// axios.post(url+'/post/lost-pets/'+'/',datos,config)//publicar
// axios.delete(url+'/post/lost-pets/'+id+'/',config)//eliminar
console.log(xd);

