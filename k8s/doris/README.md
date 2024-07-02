kubectl apply -f k8s/doris/doris.selectdb.com_dorisclusters.yaml  

kubectl get crd | grep doris   

kubectl apply -f https://raw.githubusercontent.com/selectdb/doris-operator/master/config/operator/operator.yaml

link: https://doris.apache.org/docs/install/cluster-deployment/k8s-deploy/operator-deploy/