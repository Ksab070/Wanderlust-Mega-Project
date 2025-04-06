1. Create api key
2. Run terraform code using the api keys from local (Creates the instances, the network setup and everything, also calls the userdata scripts to install and start jenkins, docker, git & other essential packages)
3. Manually create a compatible key pair for adding the slave instance as an agent, i do: 
-> ssh-keygen 
-> ssh-keygen -p -m PEM -f ~/.ssh/id_rsa (Convert the keypair file to compatible format)
4. Login to the slave instance, add the id_rsa.pub content into the ~/.ssh/authorized_keys file
5. Check if the keys got added successfully using: ssh ec2-user@ip
6. Login to master, to get the initial admin password for jenkins by doing cat - >toomuch effort in automating this, just login quickly 
7. login to jenkins, do the initial setup 
8. download the pipeline stage view plugin, and restart jenkins 
9. Create credentials for slave node, create slave node and launch agent 
10. Add shared library with the predefined configurations
11. Setup the pipeline and add the pull from scm and add the url and other configs. 
