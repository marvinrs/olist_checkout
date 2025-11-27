<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        // Garantir que os valores JWT são sempre inteiros
        // Isso corrige problemas quando valores vêm do cache como strings
        $jwtConfig = config('jwt');
        if (isset($jwtConfig['ttl']) && !is_int($jwtConfig['ttl'])) {
            config(['jwt.ttl' => (int) $jwtConfig['ttl']]);
        }
        if (isset($jwtConfig['refresh_ttl']) && !is_int($jwtConfig['refresh_ttl'])) {
            config(['jwt.refresh_ttl' => (int) $jwtConfig['refresh_ttl']]);
        }
        if (isset($jwtConfig['leeway']) && !is_int($jwtConfig['leeway'])) {
            config(['jwt.leeway' => (int) $jwtConfig['leeway']]);
        }
        if (isset($jwtConfig['blacklist_grace_period']) && !is_int($jwtConfig['blacklist_grace_period'])) {
            config(['jwt.blacklist_grace_period' => (int) $jwtConfig['blacklist_grace_period']]);
        }
    }
}

