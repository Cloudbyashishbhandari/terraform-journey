
provider "vault" {
    address = var.address
    skip_child_token = true
    auth_login {
      path = "auth/approle/login"

      parameters = {
        role_id = var.roll_id
        secret_id = var.secret_id
      }
    }
}
data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test-secrets"
}