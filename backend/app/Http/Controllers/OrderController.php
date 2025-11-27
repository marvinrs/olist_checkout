<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use OpenApi\Attributes as OA;

class OrderController extends Controller
{
    #[OA\Get(
        path: "/api/orders",
        summary: "Listar pedidos do usuário",
        tags: ["Pedidos"],
        security: [["bearerAuth" => []]],
        parameters: [
            new OA\Parameter(name: "per_page", in: "query", required: false, schema: new OA\Schema(type: "integer", default: 15)),
        ],
        responses: [
            new OA\Response(response: 200, description: "Lista de pedidos paginada"),
            new OA\Response(response: 401, description: "Não autenticado"),
        ]
    )]
    public function index(Request $request): JsonResponse
    {
        $orders = Order::where('user_id', auth()->id())
            ->with('items.product')
            ->orderBy('created_at', 'desc')
            ->paginate($request->get('per_page', 15));

        return response()->json($orders);
    }

    #[OA\Post(
        path: "/api/orders",
        summary: "Criar pedido",
        tags: ["Pedidos"],
        security: [["bearerAuth" => []]],
        requestBody: new OA\RequestBody(
            required: true,
            content: new OA\JsonContent(
                required: ["items", "shipping_address"],
                properties: [
                    new OA\Property(
                        property: "items",
                        type: "array",
                        items: new OA\Items(
                            type: "object",
                            properties: [
                                new OA\Property(property: "product_id", type: "integer", example: 1),
                                new OA\Property(property: "quantity", type: "integer", example: 2),
                            ]
                        )
                    ),
                    new OA\Property(
                        property: "shipping_address",
                        type: "object",
                        required: ["street", "city", "state", "zip_code", "country"],
                        properties: [
                            new OA\Property(property: "street", type: "string", example: "Rua Exemplo, 123"),
                            new OA\Property(property: "city", type: "string", example: "São Paulo"),
                            new OA\Property(property: "state", type: "string", example: "SP"),
                            new OA\Property(property: "zip_code", type: "string", example: "01234-567"),
                            new OA\Property(property: "country", type: "string", example: "Brasil"),
                        ]
                    ),
                ]
            )
        ),
        responses: [
            new OA\Response(response: 201, description: "Pedido criado com sucesso"),
            new OA\Response(response: 400, description: "Erro de validação ou estoque insuficiente"),
            new OA\Response(response: 401, description: "Não autenticado"),
        ]
    )]
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.quantity' => 'required|integer|min:1',
            'shipping_address' => 'required|array',
            'shipping_address.street' => 'required|string',
            'shipping_address.city' => 'required|string',
            'shipping_address.state' => 'required|string',
            'shipping_address.zip_code' => 'required|string',
            'shipping_address.country' => 'required|string',
        ]);

        return DB::transaction(function () use ($validated) {
            $total = 0;
            $orderItems = [];

            foreach ($validated['items'] as $item) {
                $product = Product::findOrFail($item['product_id']);

                if (!$product->active) {
                    return response()->json([
                        'message' => "O produto {$product->name} não está disponível"
                    ], 400);
                }

                if ($product->stock < $item['quantity']) {
                    return response()->json([
                        'message' => "Estoque insuficiente para o produto {$product->name}"
                    ], 400);
                }

                $itemTotal = $product->price * $item['quantity'];
                $total += $itemTotal;

                $orderItems[] = [
                    'product_id' => $product->id,
                    'quantity' => $item['quantity'],
                    'price' => $product->price,
                ];

                $product->decrement('stock', $item['quantity']);
            }

            $order = Order::create([
                'user_id' => auth()->id(),
                'status' => 'pending',
                'total' => $total,
                'shipping_address' => $validated['shipping_address'],
            ]);

            foreach ($orderItems as $item) {
                $order->items()->create($item);
            }

            return response()->json($order->load('items.product'), 201);
        });
    }

    #[OA\Get(
        path: "/api/orders/{id}",
        summary: "Obter pedido",
        tags: ["Pedidos"],
        security: [["bearerAuth" => []]],
        parameters: [
            new OA\Parameter(name: "id", in: "path", required: true, schema: new OA\Schema(type: "integer")),
        ],
        responses: [
            new OA\Response(response: 200, description: "Dados do pedido"),
            new OA\Response(response: 403, description: "Não autorizado"),
            new OA\Response(response: 404, description: "Pedido não encontrado"),
        ]
    )]
    public function show(Order $order): JsonResponse
    {
        if ($order->user_id !== auth()->id()) {
            return response()->json(['message' => 'Não autorizado'], 403);
        }

        return response()->json($order->load('items.product'));
    }

    #[OA\Put(
        path: "/api/orders/{id}",
        summary: "Atualizar pedido",
        tags: ["Pedidos"],
        security: [["bearerAuth" => []]],
        parameters: [
            new OA\Parameter(name: "id", in: "path", required: true, schema: new OA\Schema(type: "integer")),
        ],
        requestBody: new OA\RequestBody(
            required: true,
            content: new OA\JsonContent(
                properties: [
                    new OA\Property(
                        property: "status",
                        type: "string",
                        enum: ["pending", "processing", "shipped", "delivered", "cancelled"],
                        example: "processing"
                    ),
                ]
            )
        ),
        responses: [
            new OA\Response(response: 200, description: "Pedido atualizado"),
            new OA\Response(response: 403, description: "Não autorizado"),
            new OA\Response(response: 404, description: "Pedido não encontrado"),
        ]
    )]
    public function update(Request $request, Order $order): JsonResponse
    {
        if ($order->user_id !== auth()->id()) {
            return response()->json(['message' => 'Não autorizado'], 403);
        }

        $validated = $request->validate([
            'status' => 'sometimes|in:pending,processing,shipped,delivered,cancelled',
        ]);

        $order->update($validated);

        return response()->json($order->load('items.product'));
    }
}

