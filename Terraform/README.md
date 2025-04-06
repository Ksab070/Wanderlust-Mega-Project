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