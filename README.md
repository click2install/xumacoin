# Xuma Coin

Shell script to install an [Xuma Masternode](https://bitcointalk.org/index.php?topic=2976421.0) on a Linux server running Ubuntu 16.04.

## Installation 
```
wget -q https://raw.githubusercontent.com/click2install/xumacoin/master/install-xuma.sh  
bash install-xuma.sh
```

Donations for the creation and maintenance of this script are welcome at:
&nbsp;

XUMA: XWKSQTpNqx63tuNdKnxvLAuX6sz1GCVWY6

&nbsp;

## How to setup your masternode with this script and a cold wallet on your PC
The script assumes you are running a cold wallet on your local PC and this script will execute on a Ubuntu Linux VPS (server). The steps involved are:

 1. Run this script as the instructions detail below
 2. When you are finished this process you will get some infomration on what has been done as well as some important information you will need for your cold wallet setup
 3. Copy/paste the output of this script into a text file and keep it safe.

You are now ready to configure your local wallet and finish the masternode setup

 1. Make sure you have downloaded the latest wallet from https://github.com/xumacoin/xuma-core/releases
 2. Install the wallet on your local PC
 3. Start the wallet and let if completely synchronize to the network - this will take some time
 4. Make sure you have at least 1000.00002 ELP in your wallet
 5. Open your wallet debug console by going to Tools > Debug Console
 6. In the console type: `getnewaddress [address-name]` - e.g. `getnewaddress mn1`
 7. In the console type: `sendtoaddress [output from #6] 1000`
 8. Wait for the transaction from #7 to be fully confirmed. Look for a tick in the first column in your transactions tab
 9. Once confirmed, type in your console: `masternode outputs`
 10. Open your masternode configuration file from Tools > Open Masternode Configuration File
 11. In your masternodes.conf file add an entry that looks like: `[address-name from #6] [ip:port of your VPS] [privkey from script output] output index [txid from from #9] [output index from #9]` - 
 12. Your masternodes.conf file entry should look like: `MN-1 127.0.0.2:6110 93HaYBVUCYjEMeeH1Y4sBGLALQZE1Yc1K64xiqgX37tGBDQL8Xg 2bcd3c84c84f87eaa86e4e56834c92927a07f9e18718810b92e0d0324456a67c 0`
 13. Save and close your masternodes.conf file
 14. Close your wallet and restart
 15. Go to Masternodes > My MasterNodes
 16. Click the row for the masternode you just added
 17. Right click > Start Alias
 18. Your node should now be running successfully.

&nbsp;


## Multiple master nodes on one server
The script does not support installing multiple masternodes on the same host.

&nbsp;


## Running the script
When you run the script it will tell you what it will do on your system. Once completed there is a summary of the information you need to be aware of regarding your node setup which you can copy/paste to your local PC.

If you want to run the script before setting up the node in your cold wallet the script will generate a priv key for you to use, otherwise you can supply the privkey during the script execution.

&nbsp;

## Security
The script allows for a custom SSH port to be specified as well as setting up the required firewall rules to only allow inbound SSH and node communications, whilst blocking all other inbound ports and all outbound ports.

The [fail2ban](https://www.fail2ban.org/wiki/index.php/Main_Page) package is also used to mitigate DDoS attempts on your server.

Despite this script needing to run as `root` you should secure your Ubuntu server as normal with the following precautions:

 - disable password authentication
 - disable root login
 - enable SSH certificate login only

If the above precautions are taken you will need to `su root` before running the script.

&nbsp;

## Disclaimer
Whilst effort has been put into maintaining and testing this script, it will automatically modify settings on your Ubuntu server - use at your own risk. By downloading this script you are accepting all responsibility for any actions it performs on your server.

&nbsp;






