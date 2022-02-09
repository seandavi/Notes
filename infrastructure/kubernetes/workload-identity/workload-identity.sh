#!/bin/bash

# CREATE A NEW cluster
# gcloud container clusters create autopilot-cluster-2 \
#     --region=us-central1 \
#     --workload-pool=omicidx-338300.svc.id.goog

# UPDATE AN EXISTING cluster
# NOTE that autopilot clusters already have workload identity on
# gcloud container clusters update autopilot-cluster-2 \
#     --region=us-central1 \
#     --workload-pool=omicidx-338300.svc.id.goog


kubectl create serviceaccount gcp-workload-identity \
    --namespace default

gcloud iam service-accounts create kubernetes-cluster-account \
    --project=omicidx-338300

# roles:
#  storage:    https://cloud.google.com/storage/docs/access-control/iam-roles
#  bigquery:   https://cloud.google.com/bigquery/docs/access-control
#  pubsub:     https://cloud.google.com/pubsub/docs/access-control
gcloud projects add-iam-policy-binding omicidx-338300 \
    --member "serviceAccount:kubernetes-cluster-account@omicidx-338300.iam.gserviceaccount.com" \
    --role "roles/storage.admin"
gcloud projects add-iam-policy-binding omicidx-338300 \
    --member "serviceAccount:kubernetes-cluster-account@omicidx-338300.iam.gserviceaccount.com" \
    --role "roles/bigquery.admin" \
gcloud projects add-iam-policy-binding omicidx-338300 \
    --member "serviceAccount:kubernetes-cluster-account@omicidx-338300.iam.gserviceaccount.com" \
    --role "roles/pubsub.admin"

gcloud iam service-accounts add-iam-policy-binding kubernetes-cluster-account@omicidx-338300.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:omicidx-338300.svc.id.goog[default/gcp-workload-identity]"

kubectl annotate serviceaccount gcp-workload-identity \
    --namespace default \
    iam.gke.io/gcp-service-account=kubernetes-cluster-account@omicidx-338300.iam.gserviceaccount.com
