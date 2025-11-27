<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use OpenApi\Attributes as OA;

class ProductController extends Controller
{
    #[OA\Get(
        path: "/api/products",
        summary: "Listar produtos",
        tags: ["Produtos"],
        parameters: [
            new OA\Parameter(name: "search", in: "query", required: false, schema: new OA\Schema(type: "string")),
            new OA\Parameter(name: "active", in: "query", required: false, schema: new OA\Schema(type: "boolean")),
            new OA\Parameter(name: "per_page", in: "query", required: false, schema: new OA\Schema(type: "integer", default: 15)),
        ],
        responses: [
            new OA\Response(response: 200, description: "Lista de produtos paginada"),
        ]
    )]
    public function index(Request $request): JsonResponse
    {
        $query = Product::query();

        if ($request->has('search')) {
            $query->where(function ($q) use ($request) {
                $q->where('name', 'like', '%' . $request->search . '%')
                  ->orWhere('description', 'like', '%' . $request->search . '%')
                  ->orWhere('sku', 'like', '%' . $request->search . '%');
            });
        }

        if ($request->has('active')) {
            $query->where('active', $request->boolean('active'));
        }

        $products = $query->paginate($request->get('per_page', 15));

        return response()->json($products);
    }

    #[OA\Post(
        path: "/api/products",
        summary: "Criar produto",
        tags: ["Produtos"],
        security: [["bearerAuth" => []]],
        requestBody: new OA\RequestBody(
            required: true,
            content: new OA\JsonContent(
                required: ["name", "price", "stock", "sku"],
                properties: [
                    new OA\Property(property: "name", type: "string", example: "Produto Exemplo"),
                    new OA\Property(property: "description", type: "string", nullable: true),
                    new OA\Property(property: "price", type: "number", format: "float", example: 99.90),
                    new OA\Property(property: "stock", type: "integer", example: 100),
                    new OA\Property(property: "sku", type: "string", example: "PROD-001"),
                    new OA\Property(property: "image", type: "string", nullable: true),
                    new OA\Property(property: "active", type: "boolean", example: true),
                ]
            )
        ),
        responses: [
            new OA\Response(response: 201, description: "Produto criado com sucesso"),
            new OA\Response(response: 422, description: "Erro de validação"),
        ]
    )]
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'sku' => 'required|string|unique:products,sku',
            'image' => 'nullable|string',
            'active' => 'boolean',
        ]);

        $product = Product::create($validated);

        return response()->json($product, 201);
    }

    #[OA\Get(
        path: "/api/products/{id}",
        summary: "Obter produto",
        tags: ["Produtos"],
        parameters: [
            new OA\Parameter(name: "id", in: "path", required: true, schema: new OA\Schema(type: "integer")),
        ],
        responses: [
            new OA\Response(response: 200, description: "Dados do produto"),
            new OA\Response(response: 404, description: "Produto não encontrado"),
        ]
    )]
    public function show(Product $product): JsonResponse
    {
        return response()->json($product);
    }

    #[OA\Put(
        path: "/api/products/{id}",
        summary: "Atualizar produto",
        tags: ["Produtos"],
        security: [["bearerAuth" => []]],
        parameters: [
            new OA\Parameter(name: "id", in: "path", required: true, schema: new OA\Schema(type: "integer")),
        ],
        requestBody: new OA\RequestBody(
            required: true,
            content: new OA\JsonContent(
                properties: [
                    new OA\Property(property: "name", type: "string"),
                    new OA\Property(property: "description", type: "string", nullable: true),
                    new OA\Property(property: "price", type: "number", format: "float"),
                    new OA\Property(property: "stock", type: "integer"),
                    new OA\Property(property: "sku", type: "string"),
                    new OA\Property(property: "image", type: "string", nullable: true),
                    new OA\Property(property: "active", type: "boolean"),
                ]
            )
        ),
        responses: [
            new OA\Response(response: 200, description: "Produto atualizado"),
            new OA\Response(response: 404, description: "Produto não encontrado"),
        ]
    )]
    public function update(Request $request, Product $product): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'sometimes|required|numeric|min:0',
            'stock' => 'sometimes|required|integer|min:0',
            'sku' => 'sometimes|required|string|unique:products,sku,' . $product->id,
            'image' => 'nullable|string',
            'active' => 'boolean',
        ]);

        $product->update($validated);

        return response()->json($product);
    }

    #[OA\Delete(
        path: "/api/products/{id}",
        summary: "Deletar produto",
        tags: ["Produtos"],
        security: [["bearerAuth" => []]],
        parameters: [
            new OA\Parameter(name: "id", in: "path", required: true, schema: new OA\Schema(type: "integer")),
        ],
        responses: [
            new OA\Response(response: 200, description: "Produto deletado com sucesso"),
            new OA\Response(response: 404, description: "Produto não encontrado"),
        ]
    )]
    public function destroy(Product $product): JsonResponse
    {
        $product->delete();

        return response()->json(['message' => 'Produto deletado com sucesso']);
    }
}

