'use client'

import { useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/contexts/AuthContext'
import { useCart } from '@/contexts/CartContext'
import Layout from '@/components/Layout'
import Link from 'next/link'

export default function CartPage() {
  const { user, loading: authLoading } = useAuth()
  const { items, removeItem, updateQuantity, getTotalPrice } = useCart()
  const router = useRouter()

  useEffect(() => {
    if (!authLoading && !user) {
      router.push('/login')
    }
  }, [user, authLoading, router])

  if (authLoading) {
    return (
      <Layout>
        <div className="text-center py-12">Carregando...</div>
      </Layout>
    )
  }

  if (!user) {
    return null
  }

  const handleQuantityChange = (productId: number, newQuantity: number) => {
    try {
      updateQuantity(productId, newQuantity)
    } catch (error: any) {
      alert(error.message)
    }
  }

  if (items.length === 0) {
    return (
      <Layout>
        <div className="px-4 py-6 sm:px-0">
          <h1 className="text-3xl font-bold text-gray-900 mb-6">Carrinho de Compras</h1>
          <div className="bg-white rounded-lg shadow-md p-12 text-center">
            <p className="text-gray-600 text-lg mb-4">Seu carrinho está vazio</p>
            <Link
              href="/products"
              className="inline-block bg-primary-600 text-white px-6 py-3 rounded-lg hover:bg-primary-700 transition-colors"
            >
              Continuar Comprando
            </Link>
          </div>
        </div>
      </Layout>
    )
  }

  return (
    <Layout>
      <div className="px-4 py-6 sm:px-0">
        <h1 className="text-3xl font-bold text-gray-900 mb-6">Carrinho de Compras</h1>
        <div className="bg-white shadow overflow-hidden sm:rounded-md">
          <ul className="divide-y divide-gray-200">
            {items.map((item) => (
              <li key={item.product.id} className="p-6">
                <div className="flex items-center justify-between">
                  <div className="flex-1">
                    <h3 className="text-lg font-semibold text-gray-900">{item.product.name}</h3>
                    <p className="text-sm text-gray-500 mt-1">{item.product.description}</p>
                    <p className="text-sm text-gray-500">SKU: {item.product.sku}</p>
                    <p className="text-sm text-gray-500">Estoque disponível: {item.product.stock}</p>
                  </div>
                  <div className="flex items-center space-x-4 ml-6">
                    <div className="flex items-center space-x-2">
                      <button
                        onClick={() => handleQuantityChange(item.product.id, item.quantity - 1)}
                        className="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center hover:bg-gray-100 transition-colors"
                        disabled={item.quantity <= 1}
                      >
                        <span className="text-gray-600">−</span>
                      </button>
                      <span className="w-12 text-center font-medium">{item.quantity}</span>
                      <button
                        onClick={() => handleQuantityChange(item.product.id, item.quantity + 1)}
                        className="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center hover:bg-gray-100 transition-colors"
                        disabled={item.quantity >= item.product.stock}
                      >
                        <span className="text-gray-600">+</span>
                      </button>
                    </div>
                    <div className="text-right min-w-[120px]">
                      <p className="text-lg font-semibold text-gray-900">
                        R$ {(Number(item.product.price) * item.quantity).toFixed(2)}
                      </p>
                      <p className="text-sm text-gray-500">
                        R$ {Number(item.product.price).toFixed(2)} cada
                      </p>
                    </div>
                    <button
                      onClick={() => removeItem(item.product.id)}
                      className="ml-4 text-red-600 hover:text-red-800 transition-colors"
                      title="Remover do carrinho"
                    >
                      <svg
                        className="w-6 h-6"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth={2}
                          d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                        />
                      </svg>
                    </button>
                  </div>
                </div>
              </li>
            ))}
          </ul>
        </div>
        <div className="mt-6 bg-white rounded-lg shadow-md p-6">
          <div className="flex justify-between items-center mb-4">
            <span className="text-xl font-semibold text-gray-900">Total:</span>
            <span className="text-2xl font-bold text-primary-600">
              R$ {getTotalPrice().toFixed(2)}
            </span>
          </div>
          <div className="flex space-x-4">
            <Link
              href="/products"
              className="flex-1 text-center bg-gray-200 text-gray-800 px-6 py-3 rounded-lg hover:bg-gray-300 transition-colors font-medium"
            >
              Continuar Comprando
            </Link>
            <Link
              href="/checkout"
              className="flex-1 text-center bg-primary-600 text-white px-6 py-3 rounded-lg hover:bg-primary-700 transition-colors font-medium"
            >
              Finalizar Compra
            </Link>
          </div>
        </div>
      </div>
    </Layout>
  )
}

