# Build the image using local Docker CLI (works because your manual build succeeds)
resource "null_resource" "build_image" {
  # Rebuild if Dockerfile or index.html changes
  triggers = {
    dockerfile_hash = filesha256("${path.module}/Dockerfile")
    index_hash      = filesha256("${path.module}/index.html")
  }

  provisioner "local-exec" {
    command = "docker build -t dockerized_webapp:latest -f Dockerfile ."
  }
}

# Then run the container using the image we just built
resource "docker_container" "web" {
  name       = "dockerized-webapp"
  image      = "dockerized_webapp:latest"
  depends_on = [null_resource.build_image]

ports {
  internal = 80
  external = 8081   # was 8080
    }
}
