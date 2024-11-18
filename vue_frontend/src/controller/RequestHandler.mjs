import axios from 'axios';

export class RequestHandler {

    constructor() {
        this.handler = axios.create({
            baseURL: "http://localhost:8080",
        });
    }

    getCookie(name) {
        let cookieValue = null;
        if (document.cookie && document.cookie !== '') {
            const cookies = document.cookie.split(';');
            for (let i = 0; i < cookies.length; i++) {
                const cookie = cookies[i].trim();
                if (cookie.substring(0, name.length + 1) === (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }

    async checkConnection() {
        try {
            var res = await this.handler.get("/health_check");
            return res;
        } catch (error) {
            this.handleError(error);
        }
    }

    async getRequest(url, par = {}) {
        let csrf = this.getCookie('csrftoken');
        try {
            var res = await this.handler.get(
                url,
                {
                    params: par,
                    headers: {
                        'X-CSRFToken': csrf,
                    },
                    withCredentials: true,
                }
            );
            return res;
        } catch (error) {
            this.handleError(error);
        }
    }

    async postRequest(url, data = {}, par = {}) {
        let csrf = this.getCookie('csrftoken');
        try {
            var res = await this.handler.post(
                url,
                data,
                {
                    params: par,
                    headers: {
                        'X-CSRFToken': csrf,
                    },
                    withCredentials: true,
                }
            );
            return res;
        } catch (error) {
            this.handleError(error);
        }
    }

    async putRequest(url, data = {}, par = {}) {
        let csrf = this.getCookie('csrftoken');
        try {
            var res = await this.handler.put(
                url,
                data,
                {
                    params: par,
                    headers: {
                        'X-CSRFToken': csrf,
                    },
                    withCredentials: true,
                }
            );
            return res;
        } catch (error) {
            this.handleError(error);
        }
    }

    async deleteRequest(url, par = {}) {
        let csrf = this.getCookie('csrftoken');
        try {
            var res = await this.handler.delete(
                url,
                {
                    params: par,
                    headers: {
                        'X-CSRFToken': csrf,
                    },
                    withCredentials: true,
                }
            );
            return res;
        } catch (error) {
            this.handleError(error);
        }
    }

    handleError(error) {
        if (error.response) {
            console.error('Error Response Data:', error.response.data);
            console.error('Error Response Status:', error.response.status);
            console.error('Error Response Headers:', error.response.headers);
        } else if (error.request) {
            console.error('No response received:', error.request);
        } else {
            console.error('Request Error:', error.message);
        }
        console.error('Config:', error.config);
    }
}
