# Xuma Coin

Shell script to install and remove a [Xuma Masternode](https://bitcointalk.org/index.php?topic=2976421.0) on a Linux server running Ubuntu 16.04.

## Contents

  - [Installation](#Installation)
  - [How to setup your masternode with this script and a cold wallet on your PC](#how-to-setup-your-masternode-with-this-script-and-a-cold-wallet-on-your-PC)
  - [Multiple master nodes on one server](#multiple-master-nodes-on-one-server)
  - [Running the install script](#running-the-install-script)
  - [Removing a master node](#removing-a-master-node)
  - [How to tell my master node is "actually" running properly](#how-to-tell-my-master-node-is-actually-running-properly)
  - [Security](#security)
  - [Disclaimer](#disclaimer)



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
 4. Make sure you have at least 10000.00002 XMX in your wallet
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


## Running the install script
When you run the `install-xuma.sh` script it will tell you what it will do on your system. Once completed there is a summary of the information you need to be aware of regarding your node setup which you can copy/paste to your local PC.

If you want to run the script before setting up the node in your cold wallet the script will generate a priv key for you to use, otherwise you can supply the privkey during the script execution.

&nbsp;


## Removing a master node
If you have used the `install-xuma.sh` script to install your masternode and you want to remove it. You can run `remove-xuma.sh` to clean your server of all files and folders that the installation script created.

For removal, run the following commands from your server:

```
wget -q https://raw.githubusercontent.com/click2install/xumacoin/master/remove-xuma.sh  
bash remove-xuma.sh
rm -f remove-xuma.sh
```

&nbsp;


## How to tell my master node is "actually" running properly
Sometimes it looks like your masternode is running, when looking at your wallet but it is not always the case. To check it is running you can do the follwing test.

NOTE: that if you clicked “Start” soon after you ran your node on the VPS, there is a good chance the wallet says it is “ENABLED” when it actually isn’t, you need to perform the steps below to make sure it is. It is best to wait until the node is synced to the current date before starting your node from the wallet, this not only ensures it starts properly, but it also allows you to more easily see the log output.


### Check the log files on the VPS
Login to the VPS and run `tail -f /home/<username>/.xuma/mainnet/debug.log` where `<username>` is the username you installed your node with using the script above.

This will `continutally` show the last 10 or so lines of the log file until we cancel it (at the end of this section). 

Note, if you see many lines that look like:

```
ProcessBlock: ORPHAN BLOCK 16, prev=89f920965c1bfa54535be2121ec84c4c060eebc5ef0075f9979852c486473f5d
SetBestChain: new best=e63d5078dd3c5e7521e93541080ebbefb3061ad436f032198473370090291f0a height=16010
```

Then the wallet is not yet fully synced, watch the time entry on the left and wait until it reaches today’s date and the entries will stop flying by and give you a chance to find the entry like:

```
CActiveMasternode::Dseep() — RelayMasternodeEntryPing vin = CTxIn(COutPoint(16344302e, 1), scriptSig=)
```

Once the output slows down, if you do not see this appear within a minute or so of watching, you may have a problem, you then need to look for an entry like:

```
CActiveMasternode::Dseep()  - Error: masternode is not in a running status
```

If you see the error above, go back to your wallet and click the “Start” button again for the masternode you want to start. In the VPS log output you should then see:

```
CActiveMasternode::EnableHotColdMasterNode() — Enabled! You may shut down the cold daemon.
```

Subsequent output starting with `CActiveMasternode` which should appear about every minute, should then show output like:

```
CActiveMasternode::Dseep() — RelayMasternodeEntryPing vin = CTxIn(COutPoint(16344302e, 1), scriptSig=)
```

This now means your masternode is running properly and you will soon be receiving rewards. 

If you dont see the `Enabled! You may shut down the cold daemon` line appear when you click Start:

 - wait a few minutes 
 - click Start again
 - then check the VPS log tail output
 
Sometimes your masternode needs time to broadcast itself to the network before this command will work correctly. The time that takes varies based on the amount of network activity.

Press Ctrl + C to exit the log tail.

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






