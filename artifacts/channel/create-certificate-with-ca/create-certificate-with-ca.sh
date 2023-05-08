createcertificatesForOrg1() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/org1.supplier.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.org1.supplier.com --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-supplier-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-supplier-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-supplier-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-supplier-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.org1.supplier.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.org1.supplier.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.org1.supplier.com --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/org1.supplier.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/org1.supplier.com/peers/peer0.org1.supplier.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.org1.supplier.com -M ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/peers/peer0.org1.supplier.com/msp --csr.hosts peer0.org1.supplier.com --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/peers/peer0.org1.supplier.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.org1.supplier.com -M ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/peers/peer0.org1.supplier.com/tls --enrollment.profile tls --csr.hosts peer0.org1.supplier.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/peers/peer0.org1.supplier.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/peers/peer0.org1.supplier.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/peers/peer0.org1.supplier.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/peers/peer0.org1.supplier.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/peers/peer0.org1.supplier.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/peers/peer0.org1.supplier.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/peers/peer0.org1.supplier.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/peers/peer0.org1.supplier.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/tlsca/tlsca.org1.supplier.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/peers/peer0.org1.supplier.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/ca/ca.org1.supplier.com-cert.pem

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/org1.supplier.com/users
  mkdir -p ../crypto-config/peerOrganizations/org1.supplier.com/users/User1@org1.supplier.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.org1.supplier.com -M ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/users/User1@org1.supplier.com/msp --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/org1.supplier.com/users/Admin@org1.supplier.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca.org1.supplier.com -M ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/users/Admin@org1.supplier.com/msp --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org1.supplier.com/users/Admin@org1.supplier.com/msp/config.yaml

}

# createcertificatesForOrg1

createCertificatesForOrg2() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p /../crypto-config/peerOrganizations/org2.manufacturer.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca.org2.manufacturer.com --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2-manufacturer-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2-manufacturer-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2-manufacturer-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2-manufacturer-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ca.org2.manufacturer.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.org2.manufacturer.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.org2.manufacturer.com --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/org2.manufacturer.com/peers
  mkdir -p ../crypto-config/peerOrganizations/org2.manufacturer.com/peers/peer0.org2.manufacturer.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.org2.manufacturer.com -M ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/peers/peer0.org2.manufacturer.com/msp --csr.hosts peer0.org2.manufacturer.com --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/peers/peer0.org2.manufacturer.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.org2.manufacturer.com -M ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/peers/peer0.org2.manufacturer.com/tls --enrollment.profile tls --csr.hosts peer0.org2.manufacturer.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/peers/peer0.org2.manufacturer.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/peers/peer0.org2.manufacturer.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/peers/peer0.org2.manufacturer.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/peers/peer0.org2.manufacturer.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/peers/peer0.org2.manufacturer.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/peers/peer0.org2.manufacturer.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/peers/peer0.org2.manufacturer.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/peers/peer0.org2.manufacturer.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/tlsca/tlsca.org2.manufacturer.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/peers/peer0.org2.manufacturer.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/ca/ca.org2.manufacturer.com-cert.pem

  # --------------------------------------------------------------------------------
 
  mkdir -p ../crypto-config/peerOrganizations/org2.manufacturer.com/users
  mkdir -p ../crypto-config/peerOrganizations/org2.manufacturer.com/users/User1@org2.manufacturer.com

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.org2.manufacturer.com -M ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/users/User1@org2.manufacturer.com/msp --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/org2.manufacturer.com/users/Admin@org2.manufacturer.com

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca.org2.manufacturer.com -M ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/users/Admin@org2.manufacturer.com/msp --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org2.manufacturer.com/users/Admin@org2.manufacturer.com/msp/config.yaml

}

# createCertificateForOrg2

createCertificatesForOrg3() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/org3.distributor.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca.org3.distributor.com --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org3-distributor-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org3-distributor-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org3-distributor-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org3-distributor-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ca.org3.distributor.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.org3.distributor.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.org3.distributor.com --id.name org3admin --id.secret org3adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/org3.distributor.com/peers
  mkdir -p ../crypto-config/peerOrganizations/org3.distributor.com/peers/peer0.org3.distributor.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.org3.distributor.com -M ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/peers/peer0.org3.distributor.com/msp --csr.hosts peer0.org3.distributor.com --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/peers/peer0.org3.distributor.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.org3.distributor.com -M ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/peers/peer0.org3.distributor.com/tls --enrollment.profile tls --csr.hosts peer0.org3.distributor.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/peers/peer0.org3.distributor.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/peers/peer0.org3.distributor.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/peers/peer0.org3.distributor.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/peers/peer0.org3.distributor.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/peers/peer0.org3.distributor.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/peers/peer0.org3.distributor.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/peers/peer0.org3.distributor.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/peers/peer0.org3.distributor.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/tlsca/tlsca.org3.distributor.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/peers/peer0.org3.distributor.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/ca/ca.org3.distributor.com-cert.pem

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/org3.distributor.com/users
  mkdir -p ../crypto-config/peerOrganizations/org3.distributor.com/users/User1@org3.distributor.com

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca.org3.distributor.com -M ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/users/User1@org3.distributor.com/msp --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/org3.distributor.com/users/Admin@org3.distributor.com

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://org3admin:org3adminpw@localhost:10054 --caname ca.org3.distributor.com -M ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/users/Admin@org3.distributor.com/msp --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org3.distributor.com/users/Admin@org3.distributor.com/msp/config.yaml

}

createCretificatesForOrderer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/ordererOrganizations/supplychain.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/supplychain.com

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/supplychain.com/msp/config.yaml

  echo
  echo "Register orderer"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register orderer2"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register orderer3"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register the orderer admin"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  mkdir -p ../crypto-config/ordererOrganizations/supplychain.com/orderers
  # mkdir -p ../crypto-config/ordererOrganizations/supplychain.com/orderers/supplychain.com

  # ---------------------------------------------------------------------------
  #  Orderer

  mkdir -p ../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/msp --csr.hosts orderer.supplychain.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/tls --enrollment.profile tls --csr.hosts orderer.supplychain.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/msp/tlscacerts/tlsca.supplychain.com-cert.pem

  mkdir ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/msp/tlscacerts/tlsca.supplychain.com-cert.pem

  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p ../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer2.supplychain.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer2.supplychain.com/msp --csr.hosts orderer2.supplychain.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer2.supplychain.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer2.supplychain.com/tls --enrollment.profile tls --csr.hosts orderer2.supplychain.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer2.supplychain.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer2.supplychain.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer2.supplychain.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer2.supplychain.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer2.supplychain.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer2.supplychain.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer2.supplychain.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer2.supplychain.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer2.supplychain.com/msp/tlscacerts/tlsca.supplychain.com-cert.pem

  # mkdir ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/msp/tlscacerts
  # cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer2.supplychain.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/msp/tlscacerts/tlsca.supplychain.com-cert.pem

  # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p ../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer3.supplychain.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer3.supplychain.com/msp --csr.hosts orderer3.supplychain.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer3.supplychain.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer3.supplychain.com/tls --enrollment.profile tls --csr.hosts orderer3.supplychain.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer3.supplychain.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer3.supplychain.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer3.supplychain.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer3.supplychain.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer3.supplychain.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer3.supplychain.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer3.supplychain.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer3.supplychain.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer3.supplychain.com/msp/tlscacerts/tlsca.supplychain.com-cert.pem

  # mkdir ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/msp/tlscacerts
  # cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/orderers/orderer3.supplychain.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/msp/tlscacerts/tlsca.supplychain.com-cert.pem

  # ---------------------------------------------------------------------------

  mkdir -p ../crypto-config/ordererOrganizations/supplychain.com/users
  mkdir -p ../crypto-config/ordererOrganizations/supplychain.com/users/Admin@supplychain.com

  echo
  echo "## Generate the admin msp"
  echo
   
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/users/Admin@supplychain.com/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/supplychain.com/users/Admin@supplychain.com/msp/config.yaml

}

# createCretificateForOrderer

sudo rm -rf ../crypto-config/*
# sudo rm -rf fabric-ca/*
createcertificatesForOrg1
createCertificatesForOrg2
createCertificatesForOrg3

createCretificatesForOrderer

