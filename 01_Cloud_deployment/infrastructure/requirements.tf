terraform {
  backend "s3" {
    key                         = "terraform.tfstate"
    skip_credentials_validation = "true"
    skip_region_validation      = "true"
    bucket                      = "hr-vpp"
    endpoint                    = "https://s3.waw3-1.cloudferro.com"
    region                      = "WAW3-1"
  }
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "~> 1.30"
    }
  }

  required_version = ">= 0.14.3"
}
