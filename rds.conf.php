<?php
require 'vendor/autoload.php';

use Aws\SecretsManager\SecretsManagerClient;
use Aws\Exception\AwsException;

// Configurar o cliente do AWS SDK
$client = new SecretsManagerClient([
    'region' => 'us-east-1',
    'version' => 'latest',
]);

$secretName = 'rds!db-677b8e41-edfc-4420-a024-210aa293191f';

try {
    $result = $client->getSecretValue([
        'SecretId' => $secretName,
    ]);

    if (isset($result['SecretString'])) {
        $secret = json_decode($result['SecretString'], true);
    } else {
        $secret = json_decode(base64_decode($result['SecretBinary']), true);
    }

    $RDS_URL = 'mysql-siqhml01.cm0nugovfho6.us-east-1.rds.amazonaws.com';
    $RDS_DB = 'appoficina24';
    $RDS_user = $secret['username'];
    $RDS_pwd = $secret['password'];
    $AFF_NUM = '1';

} catch (AwsException $e) {
    echo "Erro ao obter as credenciais do Secrets Manager: " . $e->getMessage();
    exit;
}
?>