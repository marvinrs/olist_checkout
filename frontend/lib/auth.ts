import api from './api'
import Cookies from 'js-cookie'

export interface User {
  id: number
  name: string
  email: string
}

export interface LoginData {
  email: string
  password: string
}

export interface RegisterData {
  name: string
  email: string
  password: string
  password_confirmation: string
}

export const authService = {
  async login(data: LoginData) {
    const response = await api.post('/auth/login', data)
    const { token, user } = response.data
    Cookies.set('token', token, { expires: 7 })
    return { user, token }
  },

  async register(data: RegisterData) {
    const response = await api.post('/auth/register', data)
    const { token, user } = response.data
    Cookies.set('token', token, { expires: 7 })
    return { user, token }
  },

  async me() {
    const response = await api.get('/auth/me')
    return response.data
  },

  async logout() {
    try {
      await api.post('/auth/logout')
    } catch (error) {
      console.error('Logout error:', error)
    } finally {
      Cookies.remove('token')
    }
  },
}

