# Chapter 1: Create a project with AWS Management Console




## Step 1: Domain Configuration and SSL Certificates

The organization that governs domain names is called the Internet Corporation for Assigned Names and Numbers (ICANN) 
and it has made it impossible for anyone to acquire a domain name forever.

* Buy domain name with `AWS Route 53` service or another `Registrars` for example, the best in my opinion [Porkbun](https://porkbun.com)

![register domain](../assets/chapter1/register_domain.jpg)

> Create Route 53 `hosted zone`

![hosted zone](../assets/chapter1/hosted_zone.jpg)

> If you bought domain name not from AWS you'll need to reconfigure `AUTHORITATIVE NAMESERVERS` 

* Copy from created `hosted zone` your four `NS` records 

![ns records](../assets/chapter1/a_name_servers.jpg)

* Configure and Paste to your domain name registrar DNS records

> example for `porkbun` 

![porkbun ns](../assets/chapter1/domain-nameservers.jpg)

Distribution `NS` records on the top-level domain (TLD) can take from 5 minutes to 12 hours

* Next, enhance the security of your website by acquiring an `SSL` certificate through `AWS Certificate Manager (ACM)` to enable secure communication. Request a public certificate for your new domain, `thevopz_yourdomain.com`, and include a wildcard domain, `thevopz_yourdomain.com`, to ensure robust encryption and security for all subdomains under `thevopz_yourdomain.com`, utilizing a single comprehensive certificate.

![cert_request](../assets/chapter1/cert_req.jpg)

> Click `next` SSL Cert config

![ssl cert config](../assets/chapter1/ssl_config_cert.jpg)

> Create ssl cert

The certificate will initially appear as `Pending validation` as the certificate authority (CA) verifies domain ownership or control. Please be patient until the status transitions to `Issued`. Once we have our domain and a successfully issued SSL certificate, we can proceed to configure them with our CloudFront distribution."

## Step 2: Setting Up AWS CloudFront