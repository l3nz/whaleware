#! /bin/bash

DOCKERUSER=lenz
NOW=$(date --utc +"%y%m%d_%H%M")

function pushImage {

TAG=$1
IMG=$2

echo "--------------------------------------------------"
echo "Tagging $TAG as $IMG:$NOW and $IMG:latest"

docker tag -f $TAG  $DOCKERUSER/$IMG:$NOW
docker tag -f $TAG  $DOCKERUSER/$IMG:latest

docker push $DOCKERUSER/$IMG:$NOW
docker push $DOCKERUSER/$IMG:latest

}


pushImage "ast11" "asterisk-load-test-11"
pushImage "ast13" "asterisk-load-test-13"
pushImage "ast1.8" "asterisk-load-test-1.8"

