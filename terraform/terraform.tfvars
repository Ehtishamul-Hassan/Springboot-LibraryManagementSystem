ami      = "ami-00e3c023f0084cbfb"
key_name = "MumbaiKeyPair"


instances = {
  nexus = {
    az   = "ap-south-1a"
    tag  = "nexus-subnet"
    name = "nexus-server"
  }
  sonarqube = {
    az            = "ap-south-1a"
    tag           = "sonarqube-subnet"
    name          = "sonarqube-server"
    instance_type = "t3.small"
  }
}
