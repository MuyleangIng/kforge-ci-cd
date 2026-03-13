variable "TAG" {
  default = "latest"
}

target "app" {
  context    = "."
  dockerfile = "Dockerfile"
  tags       = ["flask-ci-demo:${TAG}"]
  platforms  = ["linux/amd64"]
}

group "default" {
  targets = ["app"]
}
