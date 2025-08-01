ami      = "ami-0583c2579d6458f46"
key_name = "MumbaiKeyPair"



instances = {
  nexus = {
    az            = "ap-south-1a"
    tag           = "1a"
    name          = "nexus-server"
    instance_type = "t2.micro"
    extra_tags = {
      Name        = "nexus"
      Environment = "dev"
    }
  }
  sonarqube = {
    az            = "ap-south-1a"
    tag           = "1a"
    name          = "sonarqube-server"
    instance_type = "t2.medium"
    extra_tags = {
      Name        = "sonar"
      Environment = "dev"
    }
  }
  docker = {
    az            = "ap-south-1a"
    tag           = "1a"
    name          = "docker-server"
    instance_type = "t2.micro"
    extra_tags = {
      Name        = "docker"
      Environment = "dev"
    }
  }
}
