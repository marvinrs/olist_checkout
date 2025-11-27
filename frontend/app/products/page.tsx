'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/contexts/AuthContext'
import { useCart } from '@/contexts/CartContext'
import { productService, Product } from '@/lib/products'
import Layout from '@/components/Layout'
import Link from 'next/link'

export default function ProductsPage() {
  const { user, loading: authLoading } = useAuth()
  const { addItem } = useCart()
  const router = useRouter()
  const [products, setProducts] = useState<Product[]>([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')
  const [addingToCart, setAddingToCart] = useState<number | null>(null)

  useEffect(() => {
    if (!authLoading && !user) {
      router.push('/login')
    }
  }, [user, authLoading, router])

  useEffect(() => {
    if (user) {
      loadProducts()
    }
  }, [user, search])

  const loadProducts = async () => {
    try {
      setLoading(true)
      const response = await productService.getAll({ search, active: true })
      setProducts(response.data || [])
    } catch (error) {
      console.error('Error loading products:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleAddToCart = async (product: Product) => {
    if (product.stock === 0) {
      alert('Produto sem estoque')
      return
    }

    setAddingToCart(product.id)
    try {
      addItem(product, 1)
      alert('Produto adicionado ao carrinho!')
    } catch (error: any) {
      alert(error.message || 'Erro ao adicionar produto ao carrinho')
    } finally {
      setAddingToCart(null)
    }
  }

  if (authLoading || loading) {
    return (
      <Layout>
        <div className="text-center py-12">Carregando...</div>
      </Layout>
    )
  }

  if (!user) {
    return null
  }

  return (
    <Layout>
      <div className="px-4 py-6 sm:px-0">
        <div className="flex justify-between items-center mb-6">
          <h1 className="text-3xl font-bold text-gray-900">Produtos</h1>
          <Link
            href="/products/new"
            className="bg-primary-600 text-white px-4 py-2 rounded-lg hover:bg-primary-700 transition-colors"
          >
            Novo Produto
          </Link>
        </div>
        <div className="mb-6">
          <input
            type="text"
            placeholder="Buscar produtos..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="w-full max-w-md px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
          />
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {products.map((product) => (
            <div key={product.id} className="bg-white rounded-lg shadow-md overflow-hidden">
              <div className="p-6">
                <h3 className="text-xl font-semibold text-gray-900 mb-2">{product.name}</h3>
                <p className="text-gray-600 text-sm mb-4">{product.description}</p>
                <div className="flex justify-between items-center">
                  <div>
                    <p className="text-2xl font-bold text-primary-600">R$ {Number(product.price).toFixed(2)}</p>
                    <p className="text-sm text-gray-500">Estoque: {product.stock}</p>
                  </div>
                  <div className="flex space-x-2">
                    <button
                      onClick={() => handleAddToCart(product)}
                      disabled={product.stock === 0 || addingToCart === product.id}
                      className="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition-colors text-sm disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      {addingToCart === product.id ? 'Adicionando...' : 'Adicionar ao Carrinho'}
                    </button>
                    <Link
                      href={`/products/${product.id}`}
                      className="bg-primary-600 text-white px-4 py-2 rounded-lg hover:bg-primary-700 transition-colors text-sm"
                    >
                      Ver Detalhes
                    </Link>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
        {products.length === 0 && !loading && (
          <div className="text-center py-12 text-gray-500">
            Nenhum produto encontrado
          </div>
        )}
      </div>
    </Layout>
  )
}

