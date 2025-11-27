<?php

namespace App;

use OpenApi\Attributes as OA;

#[OA\Info(
    version: "1.0.0",
    title: "Olist Checkout API",
    description: "API REST para sistema de checkout da Olist",
    contact: new OA\Contact(
        name: "Olist Checkout",
        email: "support@olist.com"
    )
)]
#[OA\Server(
    url: "http://localhost:8000",
    description: "Servidor de desenvolvimento"
)]
#[OA\SecurityScheme(
    securityScheme: "bearerAuth",
    type: "http",
    name: "Authorization",
    in: "header",
    scheme: "bearer",
    bearerFormat: "JWT"
)]
class OpenApi
{
}

