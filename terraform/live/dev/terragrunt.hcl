terraform {
  source = "../../modules/kind-cluster"
}
inputs = {
  cluster_name = "separated-cluster"
}
