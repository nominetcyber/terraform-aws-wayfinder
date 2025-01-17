module "autoscaler_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.17.0"

  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [module.eks.cluster_name]
  role_name                        = "${local.name}-cluster-autoscaler"
  tags                             = local.tags

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:autoscaler"]
    }
  }
  role_permissions_boundary_arn = var.permissions_boundary_policy_arn
}

resource "helm_release" "metrics_server" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.eks,
  ]

  namespace        = "kube-system"
  create_namespace = false

  name        = "metrics-server"
  repository  = "https://kubernetes-sigs.github.io/metrics-server"
  chart       = "metrics-server"
  version     = "3.8.2"
  max_history = 5
}

resource "helm_release" "cluster_autoscaler" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.eks,
  ]

  namespace        = "kube-system"
  create_namespace = false

  name        = "autoscaler"
  repository  = "https://kubernetes.github.io/autoscaler"
  chart       = "cluster-autoscaler"
  version     = "9.19.4"
  max_history = 5

  set {
    name  = "awsRegion"
    value = data.aws_region.current.name
  }
  set {
    name  = "autoDiscovery.clusterName"
    value = local.name
  }
  set {
    name  = "cloudProvider"
    value = "aws"
  }
  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.autoscaler_irsa_role.iam_role_arn
  }
  set {
    name  = "rbac.serviceAccount.name"
    value = "autoscaler"
  }
}
