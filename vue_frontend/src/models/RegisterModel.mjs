import axios from "axios";

let url = 'http://localhost:8080'


export const handleRegister = (email, password, name, phone , passwordc) => {
    if (!email || !password || !name || !phone || !passwordc) {
        alert('Por favor, completa todos los campos.');
        return;
    }

    if (password != passwordc) {
        alert('Contraseña no coincide.');
        return;
    }

    let user = {
        email: email,
        password: password,
        name: name,
        phone_number: phone,
        is_active: true,
        is_staff: false
    }
    let tokenS
    axios.post(url + '/user/create/', user).then((response) => {
        window.location.href = "/iniciar-sesion";
        
    }).catch((error) => {
        console.error(error);
        alert('Error al crear usuario');
      });

};