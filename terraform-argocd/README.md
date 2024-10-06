# ArgoCD Installation and GitHub Integration on EKS

## Prerequisites
- Ensure that you have a Kubernetes cluster running on EKS.
- Install `kubectl` and configure it to interact with your EKS cluster.

## Step 1: Install ArgoCD in EKS

1. Create a namespace for ArgoCD:
    ```bash
    kubectl create namespace argocd
    ```

2. Apply the ArgoCD installation manifests:
    ```bash
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    ```

3. Edit the ArgoCD Server service to use `NodePort` to access the ArgoCD UI:
    ```bash
    kubectl -n argocd edit svc argocd-server
    ```

    - In the `argocd-server` service definition, change the service type from `ClusterIP` to `NodePort`.

4. Find the public IP of the node and the NodePort to access the ArgoCD UI.

## Step 2: Access ArgoCD UI and Retrieve Initial Admin Password

1. Access the ArgoCD UI using the Node's public IP and the `NodePort`.
   
2. The default ArgoCD username is `admin`.

3. Retrieve the initial admin password:
    ```bash
    kubectl -n argocd get secret argocd-initial-admin-secret -o yaml
    ```

4. Decode the password:
    ```bash
    echo "copied-password" | base64 -d
    ```

5. Log in to the ArgoCD UI with the `admin` username and the decoded password.

6. Go to **User Info** and update your password after logging in.

## Step 3: ArgoCD Integration with GitHub (Kubernetes Manifest Repo)

1. After logging into the ArgoCD UI, go to **Applications** and click on **New Application**.

2. Fill in the application details:
   - **App Name**: Give your application a meaningful name.
   - **Project Name**: Choose `default`.
   - **Sync Policy**: Set to `Automatic`.
   - Enable **PRUNE RESOURCES** and **SELF HEAL** options.

3. Set the **Source**:
   - **Repository URL**: Enter the URL of your GitHub repository where the Kubernetes manifests are stored.
   - **Path**: Specify the path to the folder containing your manifest files (e.g., `yamls`).

4. Set the **Destination**:
   - **Cluster URL**: Choose `default` (the EKS cluster).
   - **Namespace**: Set to `default` or any other namespace as required.

5. Click on **Create** to deploy your application.

## Conclusion

You have successfully installed ArgoCD in EKS and integrated it with a GitHub repository for managing Kubernetes manifests. You can now manage your applications using ArgoCD's declarative GitOps approach.
