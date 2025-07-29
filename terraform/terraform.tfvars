ami      = "ami-0583c2579d6458f46"
key_name = "MumbaiKeyPair"


instances = {
  nexus = {
    az            = "ap-south-1a"
    tag           = "1a"
    name          = "nexus-server"
    instance_type = "t3.micro"
  }
  sonarqube = {
    az            = "ap-south-1a"
    tag           = "1a"
    name          = "sonarqube-server"
    instance_type = "t3.small"
  }
}
