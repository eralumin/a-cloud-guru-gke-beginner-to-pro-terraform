# A Cloud Guru: Google Kubernetes Engine Beginner to Pro - Terraform Labs

Terraform Scripts for all Labs in A Cloud Guru Course: Google Kubernetes Engine Beginner to Pro.

Prequisites:
- gcloud
- docker

1. Set vars in `terraform.tfvars`.
2. Comments all modules parts on `main.tf`.
2. Run `terraform apply`.
3. Then replace `{uid_prefix}` by yours from `terraform.tfvars`.and run commands below:
```bash
docker build -t gcr.io/${uid_prefix}-acg-gke/myapp ./docker_images/myapp
docker build -t gcr.io/${uid_prefix}-acg-gke/myapp:blue ./docker_images/myapp-blue
docker build -t gcr.io/${uid_prefix}-acg-gke/myapp:green ./docker_images/myapp-green
docker build -t gcr.io/${uid_prefix}-acg-gke/myapp:bad ./docker_images/myapp-bad
docker build -t gcr.io/${uid_prefix}-acg-gke/myapp:broken ./docker_images/myapp-broken
docker build -t gcr.io/${uid_prefix}-acg-gke/myapp:probes-ok ./docker_images/myapp-probes-ok
docker build -t gcr.io/${uid_prefix}-acg-gke/myapp:probes-error ./docker_images/myapp-probes-error
docker build -t gcr.io/${uid_prefix}-acg-gke/myapp:v1 ./docker_images/myapp-v1
docker build -t gcr.io/${uid_prefix}-acg-gke/myapp:v2 ./docker_images/myapp-v2
docker build -t gcr.io/${uid_prefix}-acg-gke/myapp:v3 ./docker_images/myapp-v3

docker push gcr.io/${uid_prefix}-acg-gke/myapp
docker push gcr.io/${uid_prefix}-acg-gke/myapp:blue
docker push gcr.io/${uid_prefix}-acg-gke/myapp:green
docker push gcr.io/${uid_prefix}-acg-gke/myapp:bad
docker push gcr.io/${uid_prefix}-acg-gke/myapp:broken
docker push gcr.io/${uid_prefix}-acg-gke/myapp:probes-ok
docker push gcr.io/${uid_prefix}-acg-gke/myapp:probes-error
docker push gcr.io/${uid_prefix}-acg-gke/myapp:v1
docker push gcr.io/${uid_prefix}-acg-gke/myapp:v2
docker push gcr.io/${uid_prefix}-acg-gke/myapp:v3
```
4. Uncomments modules on `main.tf`.
5. Run `terraform apply`.
