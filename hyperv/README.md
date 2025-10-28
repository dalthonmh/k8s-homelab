# Terraform with Hyper-v

Steps to install a machine virtual with terraform and hyper-v to setup an debian image server.

Installing with terraform:

```bash
terraform init
terraform apply -auto-approve
```

python -m http.server 8080

linux /install.amd/vmlinuz auto=true preseed/url=http://192.168.0.116:8080/preseed.cfg priority=critical ---
initrd /install.amd/initrd.gz
boot
