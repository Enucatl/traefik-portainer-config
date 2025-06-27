output "tunnel_token" {
  description = "The token for the Cloudflare Tunnel. Use this with `cloudflared tunnel run --token`."
  value       = data.cloudflare_zero_trust_tunnel_cloudflared_token.tunnel_token.token
  sensitive   = true 
}
