import sys
import json

ip_dict = {"cn-north-1": "43.196.20.40/29", "cn-northwest-1": "43.192.155.8/29", "us-gov-east-1": "18.252.4.0/30",
           "us-gov-west-1": "15.200.28.80/30", "af-south-1": "13.244.121.196/30", "us-west-2": "18.237.140.160/29",
           "ap-east-1": "43.198.192.104/29", "ap-northeast-1": "3.112.23.0/29", "ap-northeast-2": "13.209.1.56/29",
           "ap-northeast-3": "15.168.105.160/29", "ap-south-1": "13.233.177.0/29", "ap-south-2": "18.60.252.248/29",
           "ap-southeast-1": "3.0.5.32/29", "ap-southeast-2": "13.239.158.0/29", "ap-southeast-3": "43.218.193.64/29",
           "ap-southeast-4": "16.50.248.80/29", "ca-central-1": "35.183.92.176/29", "eu-central-1": "3.120.181.40/29",
           "eu-central-2": "16.63.77.8/29", "eu-north-1": "13.48.4.200/30", "us-west-1": "13.52.6.112/29",
           "eu-south-1": "15.161.135.164/30", "eu-south-2": "18.101.90.48/29", "eu-west-1": "18.202.216.48/29",
           "eu-west-2": "3.8.37.24/29", "eu-west-3": "35.180.112.80/29", "me-central-1": "3.29.147.40/29",
           "me-south-1": "16.24.46.56/29", "sa-east-1": "18.228.70.32/29", "us-east-1": "18.206.107.24/29",
           "us-east-2": "3.16.146.0/29"}

ip = ip_dict[sys.argv[1]]

with open("terraform.tfvars", "a") as variable_file:
    variable_file.writelines(f'\nec2_connect_ip = "{ip}"')


