This is to set up workload identity for a kubernetes cluster. See https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity for the original details.

## Usage

1. Run the approaximate script here [workload-identity.sh file](workload-identity.sh) (needs editing on names, etc.)
2. `kubectl apply -f workload-identity-test-deployment.yaml`
3. Login to the deployment: `kubectl exec -ti workload-identity-test -- /bin/bash`
4. Inside the container, try running `bq ls`, `gsutil ls`


## Identity sameness
![](https://cloud.google.com/kubernetes-engine/images/workload-identity-sameness.svg)
