module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "eks-vpc"
  cidr = var.vpc_cidr

  azs            = ["us-east-1"]
  public_subnets = ["10.100.0.0/16"]
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"
  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version

  subnet_ids      = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id

  enable_irsa = true

  eks_managed_node_groups = {
    public-nodes = {
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      subnet_ids     = module.vpc.public_subnets
    }
  }

  tags = {
    environment = "dev"
    project     = "go-web-app"
  }
}



