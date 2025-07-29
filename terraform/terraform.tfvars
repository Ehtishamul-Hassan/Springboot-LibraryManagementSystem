ami = "ami-00e3c023f0084cbfb"
key_name = "MumbaiKeyPair"


instances = {
  inst1 = {
    az   = "ap-south-1a"
    tag  = "public-subnet-1a"
    name = "terraform"
  }
#   inst2 = {
#     az   = "us-east-1b"
#     tag  = "public-subnet-1b"
#     name = "web-1b"
#   }
}
