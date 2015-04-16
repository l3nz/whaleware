#! /bin/bash

function makeImage {

IMG=$1

echo "===== BUILDING $IMG ========="

cp Dockerfile.$IMG build/Dockerfile
cd build
docker build --tag=$IMG .
cd ..


}


makeImage "ast1.8" 
makeImage "ast11" 
makeImage "ast13" 










