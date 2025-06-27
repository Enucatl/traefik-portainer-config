# Creates a new remotely-managed tunnel for the nuc10i7fnh VM.
resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id    = var.account_id
  name          = "Terraform nuc10i7fnh tunnel"
}

# Reads the token used to run the tunnel on the server.
data "cloudflare_zero_trust_tunnel_cloudflared_token" "tunnel_token" {
  account_id   = var.account_id
  tunnel_id   = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
}

# Creates the CNAME record that routes nuc10i7fnh services to the tunnel.
resource "cloudflare_dns_record" "nuc10i7fnh" {
  zone_id = var.zone_id
  name    = "nuc10i7fnh"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

# Configures tunnel with a public hostname route for clientless access.
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "tunnel_config" {
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
  account_id = var.account_id
  config     = {
    ingress   = [
      {
        hostname = "portainer.${var.zone}"
        service  = "http://portainer:9443"
      },
      {
        service  = "http_status:404"
      }
    ]
  }
}
