import axios from "axios";

let url = 'http://localhost:8080'

const tokenU = localStorage.getItem("UserToken");
let config = {
    headers: {
        Authorization: 'Token ' + tokenU,
    }
}

export async function getUsers() {
    axios.get(url+'/user/list/',config).then((response) => {
        console.log(response.data);
        return response.data;
    });
};

export const createUser = () => {

};
export const EditUser = () => {

};
export const deleteUser = () => {

};