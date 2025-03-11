$REPO_NAME="appoficina24"
$AWS_REGION="us-east-1"
$ACCOUNT_ID="339603715759"

$NEW_VERSION = "v2"

Write-Host "Nova versão: $NEW_VERSION"

# Construir a nova imagem
docker build -t $REPO_NAME`:latest -t $REPO_NAME`:$NEW_VERSION .

# Criar tags no ECR
docker tag $REPO_NAME`:$NEW_VERSION "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME`:$NEW_VERSION"
docker tag $REPO_NAME`:latest "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME`:latest"

# Autenticar no ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

# Fazer o push das imagens
docker push "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME`:$NEW_VERSION"
docker push "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME`:latest"

# Atualizar o serviço no ECS
#aws ecs update-service --cluster meu-cluster-php --service-name php-service --force-new-deployment

Write-Host "Deploy concluído! Nova versão: $NEW_VERSION (também marcado como latest)."


#aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 370882636449.dkr.ecr.us-east-1.amazonaws.com
#docker pull 370882636449.dkr.ecr.us-east-1.amazonaws.com/appoficina24:latest
