echo "run deploy.sh"

docker build -t jmatsen/multi-client:latest -t jmatsen/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t jmatsen/multi-server:latest -t jmatsen-multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t jmatsen/multi-worker:latest -t jmatsen-multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push jmatsen/multi-client:latest
docker push jmatsen/multi-server:latest
docker push jmatsen/multi-worker:latest

docker push jmatsen/multi-client:$SHA
docker push jmatsen/multi-server:$SHA
docker push jmatsen/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=jmatsen/multi-server:$SHA
kubectl set image deployments/client-deployment client=jmatsen/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=jmatsen/multi-worker:$SHA

