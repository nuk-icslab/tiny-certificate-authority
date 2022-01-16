# Host your own Certificate Authority

To simplify HTTPS development

## Dependency

- OpenSSL (Tested with v1.1.1m)
- GNU Make

# Installation

```bash
# You can download the source code from GitHub
git clone https://github.com/ifTNT/tiny-certificate-authority.git
cd tiny-certificate-authority
```

# Usage

```bash
# Generate the private key and root certificate of my CA
# You need to enter the same password three times during the whole procedure
make ca_root_cert

# Install the generated root certificate to the system
# Use p11-kit as backend, which is a common certificate registry across Linux distributions
make install_ca

# Generate the testing private key and the Certificate Signing Request (CSR) for
# the multi-domain certificate
cd req
make

# Sign the CSR with CA's private key and certificate
cd ..
make req/test.crt
```

## Configuration

| Configuration file | For                                    |
| ------------------ | -------------------------------------- |
| ca_root.conf       | CA root certificate                    |
| ca_root.conf       | The behavior of CA                     |
| reqs/test.csr.conf | CSR of sample multi-domain certificate |

## Reference

- [Manual of openssl-ca](https://www.openssl.org/docs/man1.1.1/man1/openssl-ca.html)
- [Manual of openssl-req](https://www.openssl.org/docs/man1.1.1/man1/openssl-req.html)
- [Manual of openssl-x509](https://www.openssl.org/docs/man1.1.1/man1/x509.html)
- [B. Touesnard, "Create Your Own SSL Certificate Authority for Local HTTPS Development", 2021](https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/)
