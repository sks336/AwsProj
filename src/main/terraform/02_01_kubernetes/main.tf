provider "aws" {
  region = var.aws_region
}

resource "aws_iam_instance_profile" "ssm_role" {
  name = "ssm_role"
  role = var.role_name_ssm
}

resource "aws_network_interface" "master0" {
  subnet_id       = var.subnet_id_b_prv
  private_ips     = [var.ip_address_master0]
  security_groups = [aws_security_group.k8s_nodes.id]
}

resource "aws_network_interface" "worker1" {
  subnet_id       = var.subnet_id_a_prv
  private_ips     = [var.ip_address_worker1]
  security_groups = [aws_security_group.k8s_nodes.id]
}

resource "aws_network_interface" "worker2" {
  subnet_id       = var.subnet_id_b_prv
  private_ips     = [var.ip_address_worker2]
  security_groups = [aws_security_group.k8s_nodes.id]
}

resource "aws_instance" "kube_node_control_plane" {
  ami           = var.ami_image
  instance_type = var.master_instance_type
  # subnet_id     = var.subnet_id_b_prv
  iam_instance_profile = aws_iam_instance_profile.ssm_role.name
  # vpc_security_group_ids = [aws_security_group.k8s_nodes.id]
  key_name      = var.pem_key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.master0.id
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname master0"
    ]

    connection {
      host    = self.public_ip
      type    = "ssh"
      port    = 22
      user    = "ubuntu"
      private_key = file("${var.pem_file}")
      timeout = "2m"
      agent   = false
    }
  }

  tags = {
    Name = "kc-master-0"
  }
}

resource "aws_instance" "kube_node_masters" {
  count         = (var.master_node_count)
  ami           = var.ami_image
  instance_type = var.master_instance_type
  subnet_id = element(local.subnet_ids_prv, count.index % length(local.subnet_ids_prv))
  iam_instance_profile = aws_iam_instance_profile.ssm_role.name
  # vpc_security_group_ids = [aws_security_group.k8s_nodes.id]
  key_name      = var.pem_key_name

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname master${count.index + 1}"
    ]

    connection {
      host    = self.public_ip
      type    = "ssh"
      port    = 22
      user    = "ubuntu"
      private_key = file("${var.pem_file}")
      timeout = "2m"
      agent   = false
    }
  }

  tags = {
    Name = "kc-master-${count.index + 1}"
  }
}

resource "aws_instance" "kube_node_workers" {
  count         = (var.worker_nodes_count)
  ami           = var.ami_image
  instance_type = var.master_instance_type
  # subnet_id = element(local.subnet_ids_prv, count.index % length(local.subnet_ids_prv))
  iam_instance_profile = aws_iam_instance_profile.ssm_role.name
  # vpc_security_group_ids = [aws_security_group.k8s_nodes.id]
  key_name      = var.pem_key_name

  network_interface {
    device_index         = 0
    network_interface_id = count.index == 0 ? aws_network_interface.worker1.id : aws_network_interface.worker2.id
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname worker${count.index + 1}"
    ]

    connection {
      host    = self.public_ip
      type    = "ssh"
      port    = 22
      user    = "ubuntu"
      private_key = file("${var.pem_file}")
      timeout = "2m"
      agent   = false
    }
  }

  tags = {
    Name = "kc-worker-${count.index + 1}"
  }
}


locals {
  hosts_entries_control_plane = compact(flatten([
    "echo '${aws_instance.kube_node_control_plane.private_ip} master0' | sudo tee -a /etc/hosts"
  ]))

  hosts_entries_masters = compact(flatten([
    for idx, inst in aws_instance.kube_node_masters : [
      "echo '${inst.private_ip} master${idx + 1}' | sudo tee -a /etc/hosts",
    ]
  ]))

  hosts_entries_workers = compact(flatten([
    for idx, inst in aws_instance.kube_node_workers : [
        "echo '${inst.private_ip} worker${idx + 1}' | sudo tee -a /etc/hosts",
    ]
  ]))
}


resource "null_resource" "wait_for_all_machines_to_come_up" {
  depends_on = [aws_instance.kube_node_control_plane, aws_instance.kube_node_masters, aws_instance.kube_node_workers]
  triggers = {
    always_run = timestamp()
  }

  connection {
    host    = aws_instance.kube_node_control_plane.public_ip
    type    = "ssh"
    port    = 22
    user    = "ubuntu"
    private_key = file("${var.pem_file}")
    timeout = "2m"
    agent   = false
  }

  provisioner "remote-exec" {
    inline = concat(local.hosts_entries_control_plane, local.hosts_entries_masters, local.hosts_entries_workers)
  }
}



resource "null_resource" "run_me_always_control_plane" {
  depends_on = [null_resource.wait_for_all_machines_to_come_up]
  triggers = {
    always_run = timestamp()
  }

  connection {
    host        = aws_instance.kube_node_control_plane.public_ip
    type        = "ssh"
    port        = 22
    user        = "ubuntu"
    private_key = file("${var.pem_file}")
    timeout     = "2m"
    agent       = false
  }

  provisioner "file" {
    source      = "remote_resource"
    destination = "/tmp"
  }


  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/remote_resource/scripts/*.sh",
      "sudo -H -u sachin mkdir -p /home/sachin/02_01_kube_resource",
      "sudo -H -u sachin cp -rf /tmp/remote_resource/* /home/sachin/02_01_kube_resource/",
      "sudo -H -u sachin find /home/sachin/02_01_kube_resource/ -type f -iname '*.sh' -exec chmod +x {} \\;",
      "sudo -H -u sachin /tmp/remote_resource/scripts/setup_kube_control_plane.sh"
    ]
  }

  provisioner "local-exec" {
    command = "ssh -i ${var.pem_file} -o StrictHostKeyChecking=no ubuntu@${aws_instance.kube_node_control_plane.public_ip} 'cat /home/sachin/join_worker.out' > ${path.module}/join_worker.out"
  }

  provisioner "local-exec" {
    command = "ssh -i ${var.pem_file} -o StrictHostKeyChecking=no ubuntu@${aws_instance.kube_node_control_plane.public_ip} 'cat /home/sachin/join_master.out' > ${path.module}/join_master.out"
  }
}



data "local_file" "master_join_command" {
  depends_on = [null_resource.run_me_always_control_plane]
  filename   = "${path.module}/join_master.out"
}

data "local_file" "worker_join_command" {
  depends_on = [null_resource.run_me_always_control_plane]
  filename   = "${path.module}/join_worker.out"
}

output "master_join_command" {
  value = data.local_file.master_join_command.content
}

output "worker_join_command" {
  value = data.local_file.worker_join_command.content
}

output "master0_public_ip" {
  description = "Public IP of the master0 Kubernetes node"
  value       = aws_instance.kube_node_control_plane.public_ip
}

resource "null_resource" "wait_for_master" {
  depends_on = [data.local_file.worker_join_command]

  provisioner "local-exec" {
    command = "echo 'Waiting for master to be ready...' && sleep 60"
  }
}


resource "null_resource" "run_me_always_masters" {
  count = var.master_node_count
  depends_on = [null_resource.wait_for_master]
  triggers = {
    always_run = timestamp()
  }

  connection {
    host        = aws_instance.kube_node_masters[count.index].public_ip
    type        = "ssh"
    port        = 22
    user        = "ubuntu"
    private_key = file("${var.pem_file}")
    timeout     = "2m"
    agent       = false
  }

  provisioner "remote-exec" {

    inline = [
      # "sudo hostnamectl set-hostname master${count.index+1}",
      "sudo kubeadm reset -f",
      "sudo systemctl restart kubelet",
      "set -x",
      "${data.local_file.master_join_command.content}"
    ]
  }
}


resource "null_resource" "run_me_always_worker" {
  count = var.worker_nodes_count
  depends_on = [null_resource.wait_for_master]
  triggers = {
    always_run = timestamp()
  }

  connection {
    host        = aws_instance.kube_node_workers[count.index].public_ip
    type        = "ssh"
    port        = 22
    user        = "ubuntu"
    private_key = file("${var.pem_file}")
    timeout     = "2m"
    agent       = false
  }

  provisioner "remote-exec" {

    inline = [
      # "sudo hostnamectl set-hostname worker${count.index+1}",
      "sudo kubeadm reset -f",
      "sudo systemctl restart kubelet",
      "set -x",
      "${data.local_file.worker_join_command.content}"
    ]
  }
}


# Kubernetes Security Group
resource "aws_security_group" "k8s_nodes" {
  name        = "k8s2-nodes"
  description = "Security Group for Kubernetes nodes"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["172.31.0.0/16"]
    }
  }

  ingress {
    description = "Allow ssh  from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow NodePort range from internal"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Optional: Allow all traffic within the security group (node-to-node)
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self            = true
  }

  # Egress - Allow all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
