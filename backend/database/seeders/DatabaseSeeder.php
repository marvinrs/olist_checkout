<?php

namespace Database\Seeders;

use App\Models\Product;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        User::create([
            'name' => 'Admin',
            'email' => 'admin@olist.com',
            'password' => Hash::make('password'),
        ]);

        Product::create([
            'name' => 'Produto Exemplo 1',
            'description' => 'Descrição do produto exemplo 1',
            'price' => 99.90,
            'stock' => 100,
            'sku' => 'PROD-001',
            'active' => true,
        ]);

        Product::create([
            'name' => 'Produto Exemplo 2',
            'description' => 'Descrição do produto exemplo 2',
            'price' => 149.90,
            'stock' => 50,
            'sku' => 'PROD-002',
            'active' => true,
        ]);

        Product::create([
            'name' => 'Produto Exemplo 3',
            'description' => 'Descrição do produto exemplo 3',
            'price' => 199.90,
            'stock' => 25,
            'sku' => 'PROD-003',
            'active' => true,
        ]);
    }
}

