let
  mbund = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2kbXZV9yOofK3s37lz5DDogOIp9EKuUxaOhVdczKDr";
in {
  "users/mbund/password.age".publicKeys = [mbund];
}
