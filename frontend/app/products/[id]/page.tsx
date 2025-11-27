'use client'

import { useEffect, useState } from 'react'
import { useRouter, useParams } from 'next/navigation'
import { useAuth } from '@/contexts/AuthContext'
import { useCart } from '@/contexts/CartContext'
import { productService, Product } from '@/lib/products'
import Layout from '@/components/Layout'
import Link from 'next/link'

export default function ProductDetailPage() {
  const { user, loading: authLoading } = useAuth()
  const { addItem } = useCart()
  const router = useRouter()
  const params = useParams()
  const productId = Number(params.id)
  const [product, setProduct] = useState<Product | null>(null)
  const [loading, setLoading] = useState(true)
  const [quantity, setQuantity] = useState(1)
  const [addingToCart, setAddingToCart] = useState(false)

  useEffect(() => {
    if (!authLoading && !user) {
      router.push('/login')
    }
  }, [user, authLoading, router])

  useEffect(() => {
    if (user && productId) {
      loadProduct()
    }
  }, [user, productId])

  const loadProduct = async () => {
    try {
      setLoading(true)
      const data = await productService.getById(productId)
      setProduct(data)
    } catch (error) {
      console.error('Error loading product:', error)
      router.push('/products')
    } finally {
      setLoading(false)
    }
  }

  const handleAddToCart = async () => {
    if (!product) return

    if (product.stock === 0) {
      alert('Produto sem estoque')
      return
    }

    if (quantity > product.stock) {
      alert(`Estoque insuficiente. Disponível: ${product.stock}`)
      return
    }

    setAddingToCart(true)
    try {
      addItem(product, quantity)
      alert('Produto adicionado ao carrinho!')
      router.push('/cart')
    } catch (error: any) {
      alert(error.message || 'Erro ao adicionar produto ao carrinho')
    } finally {
      setAddingToCart(false)
    }
  }

  if (authLoading || loading) {
    return (
      <Layout>
        <div className="text-center py-12">Carregando...</div>
      </Layout>
    )
  }

  if (!user || !product) {
    return null
  }

  return (
    <Layout>
      <div className="px-4 py-6 sm:px-0">
        <Link
          href="/products"
          className="text-primary-600 hover:text-primary-800 mb-4 inline-block"
        >
          ← Voltar para produtos
        </Link>

        <div className="bg-white rounded-lg shadow-md overflow-hidden">
          <div className="p-6 md:p-8">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div>
                {product.image ? (
                  <img
                    src={product.image}
                    alt={product.name}
                    className="w-full h-auto rounded-lg"
                  />
                ) : (
                  <div className="w-full h-64 bg-gray-200 rounded-lg flex items-center justify-center">
                    <span className="text-gray-400">Sem imagem</span>
                  </div>
                )}
              </div>

              <div>
                <h1 className="text-3xl font-bold text-gray-900 mb-4">{product.name}</h1>
                <p className="text-gray-600 mb-6">{product.description || 'Sem descrição'}</p>

                <div className="mb-6">
                  <p className="text-4xl font-bold text-primary-600 mb-2">
                    R$ {Number(product.price).toFixed(2)}
                  </p>
                  <p className="text-sm text-gray-500">
                    SKU: {product.sku}
                  </p>
                  <p className={`text-sm mt-2 ${product.stock > 0 ? 'text-green-600' : 'text-red-600'}`}>
                    {product.stock > 0
                      ? `Estoque disponível: ${product.stock} unidades`
                      : 'Produto sem estoque'}
                  </p>
                </div>

                {product.stock > 0 && (
                  <div className="mb-6">
                    <label htmlFor="quantity" className="block text-sm font-medium text-gray-700 mb-2">
                      Quantidade
                    </label>
                    <div className="flex items-center space-x-4">
                      <button
                        onClick={() => setQuantity(Math.max(1, quantity - 1))}
                        className="w-10 h-10 rounded-full border border-gray-300 flex items-center justify-center hover:bg-gray-100 transition-colors"
                        disabled={quantity <= 1}
                      >
                        <span className="text-gray-600">−</span>
                      </button>
                      <input
                        type="number"
                        id="quantity"
                        min="1"
                        max={product.stock}
                        value={quantity}
                        onChange={(e) => {
                          const value = parseInt(e.target.value) || 1
                          setQuantity(Math.min(Math.max(1, value), product.stock))
                        }}
                        className="w-20 text-center border border-gray-300 rounded-lg px-2 py-1"
                      />
                      <button
                        onClick={() => setQuantity(Math.min(product.stock, quantity + 1))}
                        className="w-10 h-10 rounded-full border border-gray-300 flex items-center justify-center hover:bg-gray-100 transition-colors"
                        disabled={quantity >= product.stock}
                      >
                        <span className="text-gray-600">+</span>
                      </button>
                    </div>
                  </div>
                )}

                <button
                  onClick={handleAddToCart}
                  disabled={product.stock === 0 || addingToCart}
                  className="w-full bg-primary-600 text-white px-6 py-3 rounded-lg hover:bg-primary-700 transition-colors font-medium disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {addingToCart
                    ? 'Adicionando...'
                    : product.stock > 0
                    ? 'Adicionar ao Carrinho'
                    : 'Produto Indisponível'}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  )
}

