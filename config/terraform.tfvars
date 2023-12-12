app_name         = "google"
environment_name = "terraform"


vpc_cidr = "10.0.0.0/16"
subnets-public = {
  "public_subnet1" = {
    cidr = "10.0.1.0/24"
  },
  "public_subnet2" = {
    cidr = "10.0.3.0/24"
  }
  "public_subnet3" = {
    cidr = "10.0.5.0/24"
  }
}

subnets-private = {
  "private_subnet1" = {
    cidr = "10.0.2.0/24"
  },
  "private_subnet2" = {
    cidr = "10.0.3.0/24"
  }
}


main_securitygroup_ingress = [
  {
    description = "local server"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  },
  {
    description = "jenkins"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["193.70.111.124/32"]
  }
]

main_securitygroup_egress = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]


# instance_type = "t2.micro"
# ami_id        = "ami-0173ee29ff797c346"  


instances = {
  "instance1" = {
    ami_id        = "ami-0173ee29ff797c346"
    instance_type = "t2.micro"
    subnet_index  = 1
    sg_ingress    = [
      {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    sg_egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  },
  "instance2" = {
    ami_id        = "ami-0fc5d935ebf8bc3bc"
    instance_type = "t2.small"
    subnet_index  = 2
    sg_ingress    = [
      {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    sg_egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
  # Add more instances as needed
}


# main_windows_sg_ingress = [
#   {
#     from_port = 3000
#     to_port   = 3000
#     protocol  = "tcp"
#   }
# ]

# main_windows_sg_egress = [
#   {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# ]