# Xuma Coin


####THIS SCRIPT IS UNDER FURTHER DEVELOPMENT AND SHOULD NOT BE USED TO INSTALL YOUR NODE ATM, UPDATES WILL BE POSTED HERE SOON


Shell scripts to install and remove a [Xuma Masternode](https://bitcointalk.org/index.php?topic=2976421.0) on a Linux server running Ubuntu 16.04.

## Contents

  - [Installation](#Installation)
  - [How to setup your masternode with this script and a cold wallet on your PC](#how-to-setup-your-masternode-with-this-script-and-a-cold-wallet-on-your-PC)
  - [Multiple master nodes on one server](#multiple-master-nodes-on-one-server)
  - [Running the install script](#running-the-install-script)
  - [Upgrading an existing running node](#upgrading-an-existing-running-node)
  - [Adding PC wallet configuration](#adding-pc-wallet-configuration)
  - [Removing a master node](#removing-a-master-node)
  - [When will I get a reward](#when-will-i-get-a-reward)
  - [How to tell my master node is "actually" running properly](#how-to-tell-my-master-node-is-actually-running-properly)
  - [Security](#security)
  - [Disclaimer](#disclaimer)



## Installation 
```
wget -q https://raw.githubusercontent.com/click2install/xumacoin/master/install-xuma.sh  
bash install-xuma.sh
```

**NOTE:** The istall script needs to be run as the root user. You can `su - root` once you login to change to the root user before running the script. See the [Security](#security) section below on how to setup your node so you are not logging in or installing programs into the root users account.

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
 7. In the console type: `sendtoaddress [output from #6] 10000`
 8. Wait for the transaction from #7 to be fully confirmed. Look for a tick in the first column in your transactions tab
 9. Once confirmed, type in your console: `masternode outputs`
 10. Open your masternode configuration file from Tools > Open Masternode Configuration File
 11. In your masternodes.conf file add an entry that looks like: `[address-name from #6] [ip:port of your VPS] [privkey from script output] [txid from from #9] [output index from #9]` - 
 12. Your masternodes.conf file entry should look like: `MN-1 127.0.0.2:6110 93HaYBVUCYjEMeeH1Y4sBGLALQZE1Yc1K64xiqgX37tGBDQL8Xg 2bcd3c84c84f87eaa86e4e56834c92927a07f9e18718810b92e0d0324456a67c 0`
 13. Save and close your masternodes.conf file
 14. Close your wallet and restart
 15. Open the debug console and type `masternode start-alias <address-name from #6>`
 16. Your node should now be running successfully.

&nbsp;


## Adding PC wallet configuration

A script is provided to update your local Windows wallet for the default configuration. You will need to:
 - Download the `xuma.conf.cmd` file to your wallets data directory
 - Double click the downloaded file and follow the prompts
 - This is best done before starting your wallet, if your wallet is already running, close it first then run the `xuma.conf.cmd` file

The script will add a `xuma.conf` default configuration in the folder in which the script is run.

NOTE: this script is only intended to run on a Windows PC that is not a masternode. If your PC is also a masternode, the script will work but additional information will need to be added to the generated `xuma.conf` file.

&nbsp;


## Multiple master nodes on one server
The script does not support installing multiple masternodes on the same host.

&nbsp;


## Running the install script
When you run the `install-xuma.sh` script it will tell you what it will do on your system. Once completed there is a summary of the information you need to be aware of regarding your node setup which you can copy/paste to your local PC.

If you want to run the script before setting up the node in your cold wallet the script will generate a priv key for you to use, otherwise you can supply the privkey during the script execution.

&nbsp;


## Upgrading an existing running node

If you are upgrading an existing node that was installed using the install script above, you can perform these steps to easily update the node without re-sending your Xuma collateral.

 1. Run the removal script
 2. Run the install script, when it asks for a privkey, paste your existing privkey in and do not let the script generate a new one
 3. Let your node fully sync to the network
 4. Verify it is running by reviewing [How to tell my master node is "actually" running properly](#how-to-tell-my-master-node-is-actually-running-properly)
 5. Start your node from your local PC wallet as usual

Your existing privkey can be found in your masternode.conf file, or you can locate it from the SSH shell using
```
cat /home/<username>/.xuma/mainnet/xuma.conf | grep masternodeprivkey=
```

&nbsp;

## Removing a master node
If you have used the `install-xuma.sh` script to install your masternode and you want to remove it. You can run `remove-xuma.sh` to clean your server of all files and folders that the installation script created.

For removal, run the following commands from your server:

```
wget -q https://raw.githubusercontent.com/click2install/xumacoin/master/remove-xuma.sh  
bash remove-xuma.sh
rm -f remove-xuma.sh
```

**NOTE:** The remove script needs to be run as the root user. You can `su - root` once you login to change to the root user before running the script.

#### IMPORTANT NOTE:
The removal script will permanently delete files. If you have coins in your VPS wallet, i.e., you are not running a local PC wallet that stores your coins, then you should backup the wallet.dat file on the VPS to your local PC before running the `remove-xuma` script. 


&nbsp;

## When will I get a reward?
Rewards are paid on a rank system for your node, you can use the `queue-position.sh` script to determine your rank in the queue. For first rewards, you need to cycle the queue twice and on the third time you reach the front `1` position you will receive payment.

You can run the script by using your receiving address like:

```
wget -q https://raw.githubusercontent.com/click2install/xumacoin/master/queue-position.sh  
bash queue-position.sh <receiving wallet address>
```

&nbsp;


## How to tell my master node is "actually" running properly
Sometimes it looks like your masternode is running, when looking at your wallet but it is not always the case. To check it is running you can do the follwing test.

If you started your masternode from your wallet soon after you ran your node on the VPS, there is a good chance the wallet says it is “ENABLED” when it actually isn’t, you need to perform the steps below to make sure it is. It is best to wait until the node is synced to the current date before starting your node from the wallet, this not only ensures it starts properly, but it also allows you to more easily see the log output.


### Check the log files on the VPS
Login to the VPS and run `tail -f /home/<username>/.xuma/mainnet/debug.log` where `<username>` is the username you installed your node with using the script above.

This will `continually` show the last 10 or so lines of the log file until we cancel it (at the end of this section). 

Note, you see many lines that look like:

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

If you see the error above, go back to your wallet and start your masternode again. In the VPS log output you should then see:

```
CActiveMasternode::EnableHotColdMasterNode() — Enabled! You may shut down the cold daemon.
```

Subsequent output starting with `CActiveMasternode` which should appear about every minute, should then show output like:

```
CActiveMasternode::Dseep() — RelayMasternodeEntryPing vin = CTxIn(COutPoint(16344302e, 1), scriptSig=)
```

This now means your masternode is running properly and you will soon be receiving rewards. 

If you dont see the `Enabled! You may shut down the cold daemon` line appear when you start your masternode:

 - wait a few minutes 
 - restart your masternode from the wallet
 - check the VPS log tail output
 
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

If you need assistance in the server setup there is a guide available here - https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04.

&nbsp;

## Disclaimer
Whilst effort has been put into maintaining and testing this script, it will automatically modify settings on your Ubuntu server - use at your own risk. By downloading this script you are accepting all responsibility for any actions it performs on your server.

&nbsp;






