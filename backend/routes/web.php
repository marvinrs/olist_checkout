<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json([
        'message' => 'Olist Checkout API',
        'version' => '1.0.0',
    ]);
});

