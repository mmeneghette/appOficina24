# Configurações
$REPO_NAME="appoficina24"
$AWS_REGION="us-east-1"
$ACCOUNT_ID="339603715759"

# Obter todas as tags de versão, ignorando 'latest' e mantendo apenas as versões numéricas
$LATEST_VERSIONS = aws ecr list-images --region $AWS_REGION --repository-name $REPO_NAME --query 'imageIds[*].imageTag' --output text | ` Where-Object { $_ -match '^v[0-9]+' }

# Verificar se há versões válidas
if (-not $LATEST_VERSIONS) {
    Write-Host "Nenhuma versão encontrada, iniciando com v1."
    $NEW_VERSION = "v1"
} else {
    # Ordenar as versões numericamente
    $LATEST_VERSION = $LATEST_VERSIONS | Sort-Object { [int]($_ -replace '\D+', '') } | Select-Object -Last 1

    # Remover 'v' e incrementar
    $CURRENT_NUMBER = [int]($LATEST_VERSION -replace 'v','')
    $NEW_VERSION = "v$($CURRENT_NUMBER + 1)"
}

Write-Host "Última versão encontrada: $LATEST_VERSION"
Write-Host "Nova versão será: $NEW_VERSION"
