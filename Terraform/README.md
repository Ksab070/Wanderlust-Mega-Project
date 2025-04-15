# Steps 
1. Create the infra using terraform
2. Run the command to get the initial admin password: 
ssh -o StrictHostKeyChecking=no -i for_ssh.pem ec2-user@54.144.92.208 'cat /tmp/password.txt'
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

1. create a node in jenkins 
2. download the below plugins: 
-> OWASP
-> SonarQube Scanner
-> Docker
-> Pipeline: Stage View
3. add smtp credentials in jenkins 
4. configure extended email notification setting for smtp, set smtp credentials by going to advanced
5. Add dependency check for OWASP, install automatically
6. Go to sonarcube server, create a personal access token and add that to jenkins credentials as a secret text
7. Go to system > sonarqube installations, add sonarqube (give ip and port of sonarqube) and select the credentials
8. Go to tools > and add sonarqube scanner installations, install automatically 
9. Create a pat for github for the repository access, add github credentials
10. Create a webhook in sonarqube, login > Administration > Configure > Webhooks
use URL: http://masterip:8080/sonarqube-webhook/
11. Create argocd (Go to aws cloudshell)
-> kubectl create namespace argocd
-> kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
#check if nodes are up for argocd
-> kubectl get pods -n argocd
-> sudo curl --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.4.7/argocd-linux-amd64
-> sudo chmod +x /usr/local/bin/argocd
-> kubectl get svc -n argocd
-> kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}' 
#Check if service is now nodeport
-> kubectl get svc -n argocd 
-> Browse any one of the node's public ip and the port given when you check using "kubectl get svc -n argocd"
#Fetch initial admin password and login to argocd
-> kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo     
-> Login and add github repo for the project and connect 
-> 