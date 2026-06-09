[master]
%{ for ip in masters ~}
master ansible_host=${ip}
%{ endfor }

[workers]
%{ for i, ip in workers ~}
workers${i+1} ansible_host=${ip}
%{ endfor }

[k3s_cluster:children]
master
workers

[k3s_cluster:vars]
ansible_user=ubuntu 
ansible_become_password=1234