#! /bin/bash

function dockerpull() {
	img="$1"
	ver="$2"

	echo "==== docker pull ${img}:${ver}"
	docker pull "${img}:${ver}"
}


function latest() {
	img="$1"
	dockerpull "$img" "latest"
}

latest lenz/whaleware
latest lenz/dockbooker
latest lenz/asterisk-load-test-12
latest lenz/asterisk-load-test-13
latest lenz/asterisk-load-test-11
latest lenz/asterisk-load-test-1.8

latest loway/data

versions=("latest" "22.11.3-26" "22.02.11-192" "21.04.3-52" "20.11.7-1499" "19.10.21-137" )
for v in "${versions[@]}"
do
	dockerpull loway/queuemetrics "$v"
done

versions=("latest" "21.06.4-9" "20.02.1-272" "190913a" "18.08.1-223" )
for v in "${versions[@]}"
do
	dockerpull loway/wombatdialer "$v"
done

latest loway/wbcache
