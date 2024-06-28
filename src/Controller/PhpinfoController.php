<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Attribute\Route;

class PhpinfoController extends AbstractController
{
    #[Route('/phpinfo', name: 'app_phpinfo')]
    public function index(): JsonResponse
    {
        return new JsonResponse([
            'phpinfo' => phpinfo(),
        ]);
    }
}
