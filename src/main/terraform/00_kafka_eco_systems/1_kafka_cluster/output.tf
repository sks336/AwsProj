#output "ipv4" {
#  value= aws_instance.tmp-instance[0].public_ip, aws_instance.tmp-instance[1].public_ip, aws_instance.tmp-instance[2].public_ip
#}


locals {
  publicIPs = [aws_instance.instance_master[0].public_ip, aws_instance.instance_workers[0].public_ip, aws_instance.instance_workers[1].public_ip]
  privateIPs = [aws_instance.instance_master[0].private_ip, aws_instance.instance_workers[0].private_ip, aws_instance.instance_workers[1].private_ip]
}



output "producerCommand" {
  value= "kafka-console-producer.sh --topic t1 --bootstrap-server  ${aws_instance.instance_master[0].public_ip}:9092,${aws_instance.instance_workers[0].public_ip}:9092,${aws_instance.instance_workers[1].public_ip}:9092 --property 'parse.key=true' --property 'key.separator=:'"
}

output "consumerCommand" {
  value= "kafka-console-consumer.sh --bootstrap-server  ${aws_instance.instance_master[0].public_ip}:9092,${aws_instance.instance_workers[0].public_ip}:9092,${aws_instance.instance_workers[1].public_ip}:9092 --topic t1 --from-beginning"
}
output "listCommand" {
  value= "kafka-topics.sh --bootstrap-server  ${aws_instance.instance_master[0].public_ip}:9092,${aws_instance.instance_workers[0].public_ip}:9092,${aws_instance.instance_workers[1].public_ip}:9092 --list"
}

output "prometheusURL" {
  value= "http://${aws_instance.instance_master[0].public_ip}:9090/graph"
}

output "grafanaURL" {
  value= "http://${aws_instance.instance_master[0].public_ip}:3000"
}

