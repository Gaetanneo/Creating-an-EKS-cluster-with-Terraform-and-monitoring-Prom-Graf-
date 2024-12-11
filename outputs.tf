output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.eks_cluster.name
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.eks_cluster.name}"
}

output "install_prometheus_grafana" {
  description = "Commands to install Prometheus and Grafana"
  value       = <<-EOT
    # Add Helm repos
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update

    # Create namespaces
    kubectl create namespace prometheus
    kubectl create namespace grafana

    # Install Prometheus
    helm install prometheus prometheus-community/prometheus \
      --namespace prometheus \
      --set server.persistentVolume.enabled=false \
      --set alertmanager.persistentVolume.enabled=false \
      --set server.service.type=LoadBalancer

    # Install Grafana
    helm install grafana grafana/grafana \
      --namespace grafana \
      --set persistence.enabled=false \
      --set service.type=LoadBalancer

    # Get Grafana admin password
    kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

    # Get service URLs
    kubectl get svc -n prometheus prometheus-server
    kubectl get svc -n grafana grafana
  EOT
}

# output "grafana_admin_password" {
#   description = "Command to get Grafana admin password"
#   value       = "kubectl get secret --namespace grafana grafana -o jsonpath='{.data.admin-password}' | base64 --decode"
# }
