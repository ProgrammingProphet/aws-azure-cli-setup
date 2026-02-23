# 🌩 Multi-Cloud CLI Setup Guide (Ubuntu)

This document describes installation and credential configuration for:

* **AWS CLI v2**
* **Azure CLI**
* Environment: Ubuntu 

---

# 📦 1️⃣ Install AWS CLI (v2)

We install AWS CLI using the official binary method (recommended for production environments).

---

## 🔹 Step 1 — Install Dependencies

```bash
sudo apt update
sudo apt install curl unzip -y
```

---

## 🔹 Step 2 — Download AWS CLI

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
```

---

## 🔹 Step 3 — Extract

```bash
unzip awscliv2.zip
```

---

## 🔹 Step 4 — Install

```bash
sudo ./aws/install
```

---

## 🔹 Step 5 — Verify Installation

```bash
aws --version
```

Expected output:

```
aws-cli/2.x.x Python/3.x Linux/x86_64
```

---

# 🔐 Configure AWS Credentials

⚠️ Never use root account credentials.

---

## 🔹 Step 1 — Create IAM User

1. Login to AWS Console
2. Go to IAM → Users → Create User
3. Enable **Programmatic Access**
4. Attach policy:

   * `AdministratorAccess` (for learning)
   * Later: Use least-privilege policy

Download:

* Access Key ID
* Secret Access Key

---

## 🔹 Step 2 — Configure CLI

```bash
aws configure
```

You will enter:

```
AWS Access Key ID:
AWS Secret Access Key:
Default region name (e.g., ap-south-1):
Default output format (json):
```

---

## 🔹 Step 3 — Test Configuration

```bash
aws sts get-caller-identity
```

Expected output:

```json
{
  "UserId": "...",
  "Account": "...",
  "Arn": "arn:aws:iam::xxxx:user/..."
}
```

Credentials are stored in:

```
~/.aws/credentials
~/.aws/config
```

---

# ☁ 2️⃣ Install Azure CLI

Install using Microsoft’s official repository.

---

## 🔹 Step 1 — Install Dependencies

```bash
sudo apt update
sudo apt install ca-certificates curl apt-transport-https lsb-release gnupg -y
```

---

## 🔹 Step 2 — Add Microsoft GPG Key

```bash
curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
sudo gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg
```

If file exists:

```bash
sudo rm /etc/apt/keyrings/microsoft.gpg
```

Then re-run command.

---

## 🔹 Step 3 — Add Azure Repository

```bash
AZ_REPO=$(lsb_release -cs)

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] \
https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
sudo tee /etc/apt/sources.list.d/azure-cli.list
```

---

## 🔹 Step 4 — Install Azure CLI

```bash
sudo apt update
sudo apt install azure-cli -y
```

---

## 🔹 Step 5 — Verify Installation

```bash
az version
```

Expected:

```json
{
  "azure-cli": "2.x.x"
}
```

---

# 🔐 Configure Azure Credentials

Azure CLI uses interactive authentication.

---

## 🔹 Step 1 — Login

```bash
az login
```

If WSL browser does not open:

```bash
az login --use-device-code
```

---

## 🔹 Step 2 — Verify Subscription

```bash
az account show
```

---

# 🔑 Service Principal (For CI/CD & Terraform)

⚠️ Do NOT use personal login for automation.

Create Service Principal:

```bash
az ad sp create-for-rbac --name terraform-sp
```

Output:

```json
{
  "appId": "...",
  "displayName": "...",
  "password": "...",
  "tenant": "..."
}
```

Use these in Terraform as environment variables:

```bash
export ARM_CLIENT_ID=""
export ARM_CLIENT_SECRET=""
export ARM_SUBSCRIPTION_ID=""
export ARM_TENANT_ID=""
```

---

# 🧠 DevOps Best Practices

### AWS

* Use IAM roles for EC2 instead of static credentials
* Never commit credentials to GitHub
* Use remote backend (S3 + DynamoDB)

### Azure

* Use Service Principal for automation
* Use RBAC with least privilege
* Avoid personal subscription tokens in CI/CD

---

# 🏁 Verification Checklist

| Tool       | Command                       | Status |
| ---------- | ----------------------------- | ------ |
| AWS CLI    | `aws --version`               | ✅      |
| AWS Auth   | `aws sts get-caller-identity` | ✅      |
| Azure CLI  | `az version`                  | ✅      |
| Azure Auth | `az account show`             | ✅      |

---

