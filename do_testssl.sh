#!/bin/bash
#
# milobahg
#
# Script to run a TLS test against given hostname/IP(s) from a DigitalOcean 
# droplet in London, then delete the droplet.
#
chatid="yourChatIDHere"
token="yourTokenHere"

telegramSend (){
  curl -s -F chat_id=$chatid -F document=@$PWD/testSSL_$target.txt -F caption="TestSSL report for: $target" https://api.telegram.org/bot$token/sendDocument > /dev/null
}

clear
echo "This program will create a DigitalOcean droplet based in the UK, run a TLS test and then delete itself."
  read -p "What is the hostname/IP of the target? (example.com, 194.54.23.43): " target
echo
  sleep 1
echo "Creating the droplet..."
  doctl compute droplet create testSSL --size 1gb --image docker --region lon1 --ssh-keys fe:68:31:b6:ef:79:26:11:c7:9e:40:3b:75:83:e8:f9 > /dev/null
echo "...droplet created:"
  sleep 1
echo "Waiting 60 seconds for the droplet to come online..."
  sleep 30
echo "30 Seconds left!..."
  sleep 20
echo "10 seconds left!..."
  sleep 10
echo "Now running testSSL against the target: $target"...
  doctl compute ssh testSSL --ssh-command "docker run --rm -t milobahg/testssl $target" | tee testSSL_$target.txt
echo
echo "...done!"
  sleep 1
echo "Output saved to: testSSL_$target.txt"
  telegramSend
  sleep 1
echo "Now deleting the droplet permanently...."
  doctl compute droplet delete testSSL -f
echo "...done!"
