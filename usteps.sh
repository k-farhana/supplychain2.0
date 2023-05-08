docker rm -f $(docker ps -aq) 
docker volume rm $(docker volume ls)


# git clone https://github.com/adhavpavan/FabricNetwork-2.x.git
cd artifacts/channel/create-certificate-with-ca
docker-compose up -d
./create-certificate-with-ca.sh 

cd ..
./create-artifacts.sh
cd ..
 docker-compose up -d

cd ..
# ./createChannel.sh 

# ./deployChaincode.sh

####I got error while trying to deploy : go error : 
# go mod tidy -e

####Chain code installation failed
# export DOCKER_HOST=unix:///var/run/docker.sock



# supplychain
# supplier
# manufacturer
# distributor