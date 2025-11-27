import api from './api'

export interface Product {
  id: number
  name: string
  description: string | null
  price: number
  stock: number
  sku: string
  image: string | null
  active: boolean
  created_at: string
  updated_at: string
}

export interface ProductCreate {
  name: string
  description?: string
  price: number
  stock: number
  sku: string
  image?: string
  active?: boolean
}

// Função auxiliar para normalizar produto (garantir que price seja number)
const normalizeProduct = (product: any): Product => ({
  ...product,
  price: Number(product.price),
  stock: Number(product.stock),
  id: Number(product.id),
})

export const productService = {
  async getAll(params?: { search?: string; active?: boolean; page?: number }) {
    const response = await api.get('/products', { params })
    const data = response.data
    
    // Normalizar produtos se for array
    if (Array.isArray(data)) {
      return { data: data.map(normalizeProduct) }
    }
    
    // Se for objeto com propriedade data
    if (data?.data && Array.isArray(data.data)) {
      return { ...data, data: data.data.map(normalizeProduct) }
    }
    
    return data
  },

  async getById(id: number) {
    const response = await api.get(`/products/${id}`)
    return normalizeProduct(response.data)
  },

  async create(data: ProductCreate) {
    const response = await api.post('/products', data)
    return response.data
  },

  async update(id: number, data: Partial<ProductCreate>) {
    const response = await api.put(`/products/${id}`, data)
    return response.data
  },

  async delete(id: number) {
    await api.delete(`/products/${id}`)
  },
}

