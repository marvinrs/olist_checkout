'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/contexts/AuthContext'
import Link from 'next/link'

export default function RegisterPage() {
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [passwordConfirmation, setPasswordConfirmation] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const { register } = useAuth()
  const router = useRouter()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')

    if (password !== passwordConfirmation) {
      setError('As senhas não coincidem')
      return
    }

    setLoading(true)

    try {
      await register(name, email, password, passwordConfirmation)
      router.push('/products')
    } catch (err: any) {
      const errorData = err.response?.data
      let errorMessage = 'Erro ao criar conta'
      
      if (errorData?.errors) {
        // Erros de validação do Laravel - pega o primeiro erro
        const errors = errorData.errors
        const firstFieldError = Object.values(errors)[0]
        if (Array.isArray(firstFieldError) && firstFieldError.length > 0) {
          errorMessage = firstFieldError[0] as string
        } else if (typeof firstFieldError === 'string') {
          errorMessage = firstFieldError
        }
      } else if (errorData?.message) {
        errorMessage = errorData.message
      }
      
      // Mapear mensagens de validação em inglês para português
      if (errorMessage === 'validation.unique' || errorMessage.includes('validation.unique') || errorMessage.includes('unique')) {
        errorMessage = 'Este email já está cadastrado.'
      } else if (errorMessage.includes('validation.required') || errorMessage.includes('required')) {
        errorMessage = 'Todos os campos são obrigatórios.'
      } else if (errorMessage.includes('validation.email') || errorMessage.includes('email')) {
        errorMessage = 'O email informado é inválido.'
      } else if (errorMessage.includes('validation.min.string') || errorMessage.includes('min')) {
        errorMessage = 'A senha deve ter pelo menos 8 caracteres.'
      } else if (errorMessage.includes('validation.confirmed') || errorMessage.includes('confirmed')) {
        errorMessage = 'A confirmação da senha não confere.'
      }
      
      // Se ainda for uma mensagem de validação genérica, traduzir
      if (errorMessage.startsWith('validation.')) {
        if (errorMessage.includes('unique')) {
          errorMessage = 'Este email já está cadastrado.'
        } else {
          errorMessage = 'Os dados fornecidos são inválidos. Verifique os campos do formulário.'
        }
      }
      
      setError(errorMessage)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="max-w-md w-full bg-white rounded-lg shadow-lg p-8">
        <h1 className="text-3xl font-bold text-center mb-8 text-gray-800">
          Criar Conta
        </h1>
        {error && (
          <div className="mb-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded">
            {error}
          </div>
        )}
        <form onSubmit={handleSubmit} className="space-y-6">
          <div>
            <label htmlFor="name" className="block text-sm font-medium text-gray-700 mb-2">
              Nome
            </label>
            <input
              id="name"
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent text-gray-900"
            />
          </div>
          <div>
            <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-2">
              Email
            </label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent text-gray-900"
            />
          </div>
          <div>
            <label htmlFor="password" className="block text-sm font-medium text-gray-700 mb-2">
              Senha
            </label>
            <input
              id="password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              minLength={8}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent text-gray-900"
            />
          </div>
          <div>
            <label htmlFor="passwordConfirmation" className="block text-sm font-medium text-gray-700 mb-2">
              Confirmar Senha
            </label>
            <input
              id="passwordConfirmation"
              type="password"
              value={passwordConfirmation}
              onChange={(e) => setPasswordConfirmation(e.target.value)}
              required
              minLength={8}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent text-gray-900"
            />
          </div>
          <button
            type="submit"
            disabled={loading}
            className="w-full bg-primary-600 text-white py-3 rounded-lg hover:bg-primary-700 transition-colors font-medium disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {loading ? 'Criando conta...' : 'Criar Conta'}
          </button>
        </form>
        <p className="mt-6 text-center text-sm text-gray-600">
          Já tem uma conta?{' '}
          <Link href="/login" className="text-primary-600 hover:text-primary-700 font-medium">
            Entrar
          </Link>
        </p>
      </div>
    </div>
  )
}

