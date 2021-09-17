provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "cn-hongkong"
}

# 1. VPC
data "alicloud_zones" "default" {
  available_resource_creation = "MongoDB"
}


resource "alicloud_vpc" "default" {
  vpc_name   = "vpc-mongodb"
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_vswitch" "default" {
  vpc_id       = alicloud_vpc.default.id
  cidr_block   = "172.16.0.0/24"
  zone_id      = data.alicloud_zones.default.zones[0].id
  # zone_id      = "cn-hongkong-b"
  vswitch_name = "vs-mongodb"
}

resource "alicloud_security_group" "group" {
  name        = "mongo-vs-group"
  description = "Security group for Mongodb"
  vpc_id      = alicloud_vpc.default.id
}

resource "alicloud_security_group_rule" "allow_http_3000" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "3000/3000"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_http_3100" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "3100/3100"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_http_80" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "80/80"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_http_8443" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "8443/8443"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_https_443" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "443/443"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_ssh_22" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_rdp_3389" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "3389/3389"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_all_icmp" {
  type              = "ingress"
  ip_protocol       = "icmp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

#  2. ECS
resource "alicloud_instance" "instance" {
  security_groups = alicloud_security_group.group.*.id
  instance_type           = "ecs.c5.large"
  system_disk_category    = "cloud_efficiency"
  system_disk_name        = "mongodb_system_disk"
  system_disk_size        = 40
  system_disk_description = "mongodb_system_disk"
  image_id                = "ubuntu_20_04_x64_20G_alibase_20210623.vhd"
  instance_name           = "mongodb-tech"
  password                = "Aliyuntest123" ## Please change accordingly
  instance_charge_type    = "PostPaid"
  vswitch_id              = alicloud_vswitch.default.id
}

resource "alicloud_eip" "setup_ecs_access" {
  bandwidth            = "5"
  internet_charge_type = "PayByBandwidth"
}

resource "alicloud_eip_association" "eip_ecs" {
  allocation_id = alicloud_eip.setup_ecs_access.id
  instance_id   = alicloud_instance.instance.id
}

# 3. Mongodb

resource "alicloud_mongodb_instance" "mongodb" {
  engine_version      = "4.2"
  db_instance_class   = "dds.mongo.mid"
  db_instance_storage = 10
  account_password    = "Aliyuntest123"   ## Please change accordingly
  vswitch_id          = alicloud_vswitch.default.id
  security_ip_list    = [alicloud_instance.instance.private_ip]
}


# 4. Output 

output "eip_ecs" {
  value = alicloud_eip.setup_ecs_access.ip_address
}

output "mongodb_id" {
  value = alicloud_mongodb_instance.mongodb.id
}