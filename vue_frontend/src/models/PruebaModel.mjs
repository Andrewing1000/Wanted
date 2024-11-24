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

let xd = await axios.get(url+'/user/me/',config)

let xd2 = await axios.get(url+'/post/lost-pets/',config)

axios.put(url+'/post/lost-pets/',datos,config)

axios.post(url+'/post/lost-pets/'+id+'/',datos,config)
console.log(xd2);

