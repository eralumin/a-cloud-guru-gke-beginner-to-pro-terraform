# A Cloud Guru: Google Kubernetes Engine Beginner to Pro - Terraform Labs

Terraform Scripts for all Labs in A Cloud Guru Course: Google Kubernetes Engine Beginner to Pro.

Prequisites:
- gcloud
- docker
- helm 3

1. Set vars in `terraform.tfvars`.
2. Comments all modules parts on `main.tf`.
2. Run `terraform apply`.
3. Then replace `{uid_prefix}` by yours from `terraform.tfvars`.and run commands below:
```bash
uid_prefix=your-uid-prefix
for tag in $(ls docker_images/myapp); do
    docker build -t gcr.io/${uid_prefix}-acg-gke/myapp:${tag} ./docker_images/myapp/${tag}
    docker push gcr.io/${uid_prefix}-acg-gke/myapp:${tag}
done
```
5. Download kubemci:
```bash
wget https://storage.googleapis.com/kubemci-release/release/latest/bin/linux/amd64/kubemci
chmod a+x ./kubemci
```
5. Uncomments modules on `main.tf`.
6. Run `terraform apply`.
