import axios from "axios";

let url = 'http://localhost:8080'

const tokenU = localStorage.getItem("UserToken");
let config = {
    headers: {
        Authorization: 'Token ' + tokenU,
    }
}

user = {
    email: "user@example.com",
    password: "string",
    name: "string",
    phone_number: "string",
    is_active: true,
    is_staff: true
}

export async function createUsers() {
    axios.get(url+'/user/list/',config).then((response) => {
        console.log(response.data);
        return response.data;
    });
};

export const EditUser = () => {
    
};
export const deleteUser = () => {
    
};