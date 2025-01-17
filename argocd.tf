
# resource "kubernetes_namespace" "argocd" {
#   metadata {
#     name = "argocd"
#   }
# }

# resource "helm_release" "argocd" {
#   name  = "argocd"

#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"
#   namespace = "argocd"
# }

# resource "kubernetes_manifest" "argocd_app" {
#   manifest = {
#     "apiVersion" = "argoproj.io/v1alpha1"
#     "kind"       = "Application"
#     "metadata" = {
#       "name"      = "grafana-dashboards-kubernetes"
#       "namespace" = "argocd"
#       "labels" = {
#         "app.kubernetes.io/name"       = "grafana-dashboards-kubernetes"
#         "app.kubernetes.io/version"    = "HEAD"
#         "app.kubernetes.io/managed-by" = "argocd"
#       }
#       "finalizers" = ["resources-finalizer.argocd.argoproj.io"]
#     }
#     "spec" = {
#       "project" = "default" # Update if using a custom project
#       "source" = {
#         "path"          = "./"
#         "repoURL"       = "https://github.com/dotdc/grafana-dashboards-kubernetes"
#         "targetRevision" = "HEAD"
#       }
#       "destination" = {
#         "server"    = "https://kubernetes.default.svc"
#         "namespace" = "monitoring"
#       }
#       "syncPolicy" = {
#         "automated" = {
#           "prune"    = true
#           "selfHeal" = true
#         }
#         "syncOptions" = [
#           "CreateNamespace=true",
#           "Replace=true"
#         ]
#       }
#     }
#   }
#   depends_on = [module.eks]
# }
