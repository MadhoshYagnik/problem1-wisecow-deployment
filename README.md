Go to - http://34.100.130.255/ to access the deployed application.
As required, this repository contains:

- The Wisecow application source code.
- The Dockerfile for the application.
- Kubernetes manifest files for deployment.
- The CI/CD pipeline configuration.
- A GitHub Actions workflow file for facilitating Continuous Build and Deployment (CI/CD).
- A comprehensive readme showing how is everything working.

# CI/CD Pipeline Summary

1. The pipeline is triggered by pushes to the `main` branch of the repository.

2. (Secrets) The following secrets must be configured in github actions repository secrets - DOCKER_PASSWORD, DOCKER_USERNAME, GCP_SA_KEY (GCP service account key), GKE_CLUSTER, GKE_PROJECT, GKE_ZONE, KUBECONFIG -

   DOCKER_USERNAME and DOCKER_PASSWORD:

    These secrets are used to authenticate with Docker Hub, allowing your GitHub Actions workflow to push the Docker image that was built to Docker Hub.
    DOCKER_USERNAME should be set to your Docker Hub username.
    DOCKER_PASSWORD is the password or personal access token associated with your Docker Hub account.

   GCP_SA_KEY (GCP service account key):

    This is a service account key from Google Cloud Platform (GCP) that allows GitHub Actions to authenticate and interact with your GCP resources, specifically GKE.
    Ensure that this service account has the necessary permissions (e.g., Kubernetes Engine Admin) to deploy to GKE.
    Store the contents of the service account key JSON file as the value of this secret.

   GKE_CLUSTER, GKE_PROJECT, GKE_ZONE, KUBECONFIG:

    These secrets are used for configuring and deploying to Google Kubernetes Engine (GKE):
        GKE_PROJECT: The ID of the Google Cloud project where your GKE cluster resides.
        GKE_CLUSTER: The name of the GKE cluster where you want to deploy your application.
        GKE_ZONE: The GCP zone where your GKE cluster is located.
        KUBECONFIG: This is typically used to configure authentication with your GKE cluster. You might set this secret to the contents of your kubeconfig file or a base64-encoded version of it,        depending on how your deployment script or Kubernetes configuration expects it.

3. The first job, `build-and-push`, is responsible for building and pushing a Docker image to Docker Hub. It performs the following steps:
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
