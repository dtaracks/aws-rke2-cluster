data "template_file" "client" {
  template = file("./user_data/run_on_client.sh")
}
data "template_cloudinit_config" "worker_config" {

  gzip          = false
  base64_encode = false
  #first part of local config file
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash
    echo '${aws_instance.masters["master-1"].private_ip}' > /opt/server_ip
    echo '${var.rke2_version}' > /opt/rke2_version
    EOF

  }
  #second part
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.client.rendered
  }
}

data "template_file" "server" {
  template = file("./user_data/run_on_server.sh")

}

data "template_cloudinit_config" "server_config" {
  gzip          = false
  base64_encode = false
  #first part of local config file
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash
    echo '${var.rke2_version}' > /opt/rke2_version
    EOF

  }
  #second part
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.server.rendered
  }
}

