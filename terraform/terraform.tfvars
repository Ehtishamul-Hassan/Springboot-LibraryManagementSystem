ami      = "ami-00e3c023f0084cbfb"
key_name = "MumbaiKeyPair"


instances = {
  nexus = {
    az            = "ap-south-1a"
    tag           = "1a"
    name          = "nexus-server"
    instance_type = "t2.micro"
  }
  sonarqube = {
    az            = "ap-south-1a"
    tag           = "1a"
    name          = "sonarqube-server"
    instance_type = "t3.small"
  }
}
