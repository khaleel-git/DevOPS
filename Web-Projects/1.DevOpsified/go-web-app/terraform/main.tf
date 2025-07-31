module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "eks-vpc"
  cidr = var.vpc_cidr

  azs             = ["us-east-1a"]
  public_subnets  = ["10.100.1.0/24"]

  enable_dns_hostnames = true
  map_public_ip_on_launch   = true   # ✅ this is critical for worker nodes to get public IPs

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.30"


  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni    = {
      before_compute = true
    }
  }

  enable_irsa = true
  endpoint_public_access                   = true
  enable_cluster_creator_admin_permissions = true


  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.public_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    public-nodes = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"

      min_size     = 0
      max_size     = 1
      desired_size = 1

      subnet_ids = module.vpc.public_subnets
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
    Project     = "go-web-app"
  }
}




