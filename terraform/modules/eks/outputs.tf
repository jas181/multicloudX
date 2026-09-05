output "cluster_id" { value = aws_eks_cluster.this.id }
output "cluster_endpoint" { value = aws_eks_cluster.this.endpoint }
output "cluster_oidc_issuer" { value = aws_eks_cluster.this.identity[0].oidc[0].issuer }
