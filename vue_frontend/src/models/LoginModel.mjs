import axios from "axios";

let url = 'http://localhost:8080'


export const handleLogin = (email, password) => {
    if (!email || !password) {
        alert('Por favor, completa todos los campos.');
        return;
    }

    let user = {
        email: email,
        password: password
    }
    let tokenS
    axios.post(url + '/user/token/', user).then((response) => {
        tokenS = response.data.token
        localStorage.setItem('UserToken', tokenS);

        const valor = localStorage.getItem('UserToken');
        console.log(valor);

        if (response.data.is_staff) {
            window.location.href = "/admin";
        }else{
            window.location.href = "/prueba";
        }

        

        
    }).catch((error) => {
        console.error(error);
        alert('Error al iniciar sesión');
      });

};