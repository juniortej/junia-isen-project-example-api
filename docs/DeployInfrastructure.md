### **Workflow**

Installation openssl:

    On Linux:
```sh
sudo apt-get install openssl
```

On macOS (via Homebrew):
```sh
brew install openssl
```

On Windows:

    Download the installer from **OpenSSL for Windows.**
    Follow the installation instructions.

1. **Generate Certificate**:
- Run the script:
```bash
sh generate_certificates.sh
```

#### Make the script executable:
```sh
chmod +x generate_certificates.sh deploy.sh destroy.sh
```

2. **Deploy Infrastructure**:
- Run your deployment script:
```sh
sh deploy.sh
```

3. **Updated `.env` File**:
After running the `generate_certiicates.sh`, the `shop-app/.env` file will include:
```
TF_VAR_vpn_client_root_certificate_public_cert_data=<Base64_Encoded_Certificate>
```

This ensures the generated root certificate is always updated in the environment variables for your deployment script to use.

---

### **Example `.env` File After Execution**
```
TF_VAR_admin_password=your_admin_password
TF_VAR_admin_username=your_admin_username
TF_VAR_database_name=your_database_name
TF_VAR_vpn_client_root_certificate_public_cert_data=<Base64_Encoded_Certificate>

POSTGRES_HOST=
POSTGRES_DB=
POSTGRES_USER=
POSTGRES_PASSWORD=
POSTGRES_PORT=
```

The deployment script will subsequently populate the PostgreSQL-related variables after Terraform execution.