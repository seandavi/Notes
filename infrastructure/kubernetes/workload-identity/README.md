This is to set up workload identity for a kubernetes cluster. See https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity for the original details.

Applications running on GKE might need access to Google Cloud APIs such as Compute Engine API, BigQuery Storage API, or Machine Learning APIs.

Workload Identity allows a Kubernetes service account in your GKE cluster to act as an IAM service account. Pods that use the configured Kubernetes service account automatically authenticate as the IAM service account when accessing Google Cloud APIs. Using Workload Identity allows you to assign distinct, fine-grained identities and authorization for each application in your cluster.

## How Workload Identity works

When you enable Workload Identity on a cluster, GKE automatically creates a fixed workload identity pool for the cluster's Google Cloud project. A workload identity pool allows IAM to understand and trust Kubernetes service account credentials. The workload identity pool has the following format:


PROJECT_ID.svc.id.goog

GKE uses this pool for all clusters in the project that use Workload Identity.

When you configure a Kubernetes service account in a namespace to use Workload Identity, IAM authenticates the credentials using the following member name:


serviceAccount:PROJECT_ID.svc.id.goog[KUBERNETES_NAMESPACE/KUBERNETES_SERVICE_ACCOUNT]

In this member name:

PROJECT_ID: your Google Cloud project ID.

KUBERNETES_NAMESPACE: the namespace of the Kubernetes service account.

KUBERNETES_SERVICE_ACCOUNT: the name of the Kubernetes service account making the request.

The process of configuring Workload Identity includes using an IAM policy binding to bind the Kubernetes service account member name to an IAM service account that has the permissions your workloads need. Any Google Cloud API calls from workloads that use this Kubernetes service account are authenticated as the bound IAM service account.

## Usage

1. Run the approaximate script here [workload-identity.sh file](workload-identity.sh) (needs editing on names, etc.)
2. `kubectl apply -f workload-identity-test-deployment.yaml`
3. Login to the deployment: `kubectl exec -ti workload-identity-test -- /bin/bash`
4. Inside the container, try running `bq ls`, `gsutil ls`


## Identity sameness
![](https://cloud.google.com/kubernetes-engine/images/workload-identity-sameness.svg)
