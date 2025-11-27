import api from './api'

export interface ShippingAddress {
  street: string
  city: string
  state: string
  zip_code: string
  country: string
}

export interface OrderItem {
  id: number
  order_id: number
  product_id: number
  quantity: number
  price: number
  product?: {
    id: number
    name: string
    sku: string
  }
}

export interface Order {
  id: number
  user_id: number
  status: 'pending' | 'processing' | 'shipped' | 'delivered' | 'cancelled'
  total: number
  shipping_address: ShippingAddress
  items: OrderItem[]
  created_at: string
  updated_at: string
}

export interface OrderCreate {
  items: Array<{
    product_id: number
    quantity: number
  }>
  shipping_address: ShippingAddress
}

export const orderService = {
  async getAll(params?: { page?: number }) {
    const response = await api.get('/orders', { params })
    return response.data
  },

  async getById(id: number) {
    const response = await api.get(`/orders/${id}`)
    return response.data
  },

  async create(data: OrderCreate) {
    const response = await api.post('/orders', data)
    return response.data
  },

  async update(id: number, data: { status?: Order['status'] }) {
    const response = await api.put(`/orders/${id}`, data)
    return response.data
  },
}

