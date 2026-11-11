[kube_control_plane]
%{ for ip in masters ~}
node1 ansible_host=${ip} ip=${ip} etcd_member_name=etcd1 ansible_user=ubuntu
%{ endfor }

[etcd:children]
kube_control_plane

[kube_node]
%{ for i, ip in node ~}
node${i+2} ansible_host=${ip} ip=${ip} ansible_user=ubuntu
%{ endfor }
