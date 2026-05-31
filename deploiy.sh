#!/bin/bash
set -e

echo "🚀 Micro AWS Lab - Auto Deploy"

# Colors
G='\033[0;32m'; Y='\033[1;33m'; R='\033[0;31m'; NC='\033[0m'
ok() { echo -e "${G}✓${NC} $1"; }
warn() { echo -e "${Y}!${NC} $1"; }
err() { echo -e "${R}✗${NC} $1"; exit 1; }

# Check prerequisites
command -v terraform >/dev/null || err "Install Terraform first"
command -v aws >/dev/null || err "Install AWS CLI first"
command -v docker >/dev/null || err "Install Docker first"
aws sts get-caller-identity >/dev/null || err "Configure AWS credentials first"

ok "Prerequisites OK"

# Build Lambda function
ok "Building Lambda function..."
cd functions/api
npm install --silent
cd ../..

# Deploy infrastructure
ok "Deploying infrastructure..."
cd infra
terraform init -input=false
terraform apply -auto-approve

# Get outputs
API_URL=$(terraform output -raw api_url)
ECR_URL=$(terraform output -raw ecr_url)
cd ..

# Build Docker container
ok "Building Docker container..."
cd container
docker build -t micro-app . >/dev/null

# Show container size
SIZE=$(docker images micro-app --format "{{.Size}}")
ok "Container built: $SIZE"

# Push to ECR
if [ ! -z "$ECR_URL" ]; then
  ok "Pushing to ECR..."
  aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL >/dev/null
  docker tag micro-app:latest $ECR_URL:latest
  docker push $ECR_URL:latest >/dev/null
fi
cd ..

# Test API
ok "Testing API..."
sleep 3
if curl -s "$API_URL/health" >/dev/null; then
  ok "API is working!"
else
  warn "API might still be starting"
fi

echo ""
echo "🎉 Deployment Complete!"
echo ""
echo "🔗 Your URLs:"
echo "   API: $API_URL"
echo "   Health: $API_URL/health"
echo "   Data: $API_URL/data"
echo ""
echo "🐳 Docker Commands:"
echo "   Run locally: docker run -p 3000:3000 micro-app"
echo "   Test: curl http://localhost:3000/health"
echo ""
echo "💡 Next Steps:"
echo "   1. Test API: curl $API_URL/health"
echo "   2. Post data: curl -X POST $API_URL/data -d '{\"message\":\"Hello\"}'"
echo "   3. Run container: docker run -p 3000:3000 micro-app"
echo "   4. Cleanup: ./cleanup.sh"
