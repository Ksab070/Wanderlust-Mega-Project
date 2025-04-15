# Steps 
1. Create the infra using terraform
2. Run the command to get the initial admin password: 
ssh -o StrictHostKeyChecking=no -i for_ssh.pem ec2-user@public_ip 'cat /tmp/password.txt'
3. Login to Jenkins portal, complete initial setup, install the additional plugins
-> Pipeline Stage view
-> Role Based authorizd strategy
4. Create the build agent, copy the content from for_jenkins file and directly paste it in the ssh private key.
5. Setup shared library location 
6. Setup pipeline for further process


aws eks update-kubeconfig --region us-east-1 --name wanderlust
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/aws-auth-cm.yaml
nano aws-auth-cm.yaml
kubectl apply -f aws-auth-cm.yaml
kubectl get nodes

1. create a node
2. download the below plugins: 
OWASP
SonarQube Scanner
Docker
Pipeline: Stage View
3. 