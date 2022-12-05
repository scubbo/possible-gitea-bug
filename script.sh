docker logout localhost:3000
docker logout localhost:3001

openssl req -newkey rsa:4096 -nodes -sha256 \
  -keyout ./domain.key -x509 -days 365 \
  -out ./domain.crt \
  -subj '/C=US/ST=CA/L=FakeTown/O=FakeCorp/CN=Fake Gitea Ltd./' \
  -addext 'subjectAltName=DNS:gitea-public-name.local'

docker compose up -d

sleep 10 # Necessary to ensure gitea is properly initialized

docker exec gitea_primary_name_available su git -c "gitea admin user create --username username --password password --email mail@example.org"
docker exec gitea_primary_name_unavailable su git -c "gitea admin user create --username username --password password --email mail@example.org"


echo
echo
echo
echo "================"
echo

echo "Making curl against working gitea"
curl -u "username:password" localhost:3000/v2/_catalog
echo "Attempting login to working gitea"
docker login localhost:3000 -u username -p password

echo
echo "--------------"
echo

echo "Making curl against broken gitea"
curl -u "username:password" localhost:3001/v2/_catalog
echo "Attempting login to broken gitea"
docker login localhost:3001 -u username -p password

echo
echo "================"
echo
echo
echo

echo "Services coming down"
rm domain.key
rm domain.crt
docker compose down
