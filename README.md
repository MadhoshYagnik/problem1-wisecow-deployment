As required, this repository contains:

- The Wisecow application source code.
- The Dockerfile for the application.
- Kubernetes manifest files for deployment.
- The CI/CD pipeline configuration.
- A GitHub Actions workflow file for facilitating Continuous Build and Deployment (CI/CD).

# CI/CD Pipeline Summary

1. The pipeline is triggered by pushes to the `main` branch of the repository.

2. The first job, `build-and-push`, is responsible for building and pushing a Docker image to Docker Hub. It performs the following steps:
  - Checks out the code from the repository.
  - Sets up Docker Buildx, which is a Docker CLI plugin for building multi-platform images.
  - Logs in to Docker Hub using the provided credentials.
  - Builds a Docker image from the current directory (`.`) and pushes it to Docker Hub with the tag `yagnikm/wisecow:latest`.

3. The second job, `deploy`, is responsible for deploying the application to Google Kubernetes Engine (GKE). It performs the following steps:
  - Checks out the code from the repository.
  - Authenticates with Google Cloud using the provided service account key.
  - Installs the Google Cloud SDK and the `gke-gcloud-auth-plugin`.
  - Configures `kubectl` to connect to the specified GKE cluster and zone.
  - Deploys the application to the GKE cluster by applying the `deployment.yaml` and `service.yaml` manifests.

4. The `deployment.yaml` file defines a Deployment resource for the `wisecow` application. It specifies that the application should have one replica and that the Docker image `yagnikm/wisecow:latest` should be used for the container. The container listens on port 4499.

5. The `service.yaml` file defines a Service resource for the `wisecow` application. It exposes the application on port 80 and forwards traffic to the containers on port 4499. The Service is of type `LoadBalancer`, which means it will provision a load balancer for the application, making it accessible from outside the cluster.

6. The provided Dockerfile sets up an Ubuntu-based Docker image that installs `cowsay`, `fortune-mod`, and `netcat-openbsd`. It also copies a `wisecow.sh` script to the container and sets it as the entry point for the container.

7. TLS implementation on deployed application stalled due to missing domain ownership verification.

In summary, this CI/CD pipeline builds a Docker image from the provided Dockerfile, pushes it to Docker Hub, and then deploys the image to the GKE cluster using Kubernetes manifests. The deployed application exposes a service on port 80, which runs the `wisecow.sh` script provided in the Dockerfile.
