# veeambackup:

#  Phần 1. Veeam Powered Network (VeeamPN)
If you follow Veeam, you have certainly not missed quite a few blog posts about Veeam PN (Powered Network) software. Already during VeeamON 2017, we could see a functional demo, but the solution was not GA at that time. Now Veeam has finally released the final version of Veeam PN and it's available from Azure Marketplace (Hub Appliance) and as an OVA package for local deployment (Site Gateway).
The product can be used to easily setup VPN connections over a public network.

VeeamPN At the heart of this new solution is Veeam PN, which extends an on-premises network to an Azure network, enhancing the ability to back up anything, anywhere and restore to Azure. It's designed to simplify and automate the setup of a data recovery site in Microsoft Azure.

There are two different connection scenarios possible, depending what you need/want to do:
    Site-to-site VPN between company offices and a Microsoft Azure network to which VMs restored in Microsoft Azure are connected.
    Point-to-site VPN between remote computers and a Microsoft Azure network to which VMs restored in Microsoft Azure are connected.

**There are Two components of Veeam PN:**
1. Hub Appliance – deployable from Azure Marketplace
2. Site Gateway –  downloadable from the Veeam.com website and deployed on-premises
The architecture overview below can give you more details.

![image](https://user-images.githubusercontent.com/106635733/207789463-6a9595e3-a225-4f8b-b1cd-9d734d737a5a.png)

**Veeam PN – The Features:**
1. Provides seamless and secure networking between on-premises and Azure-based IT resources
2. Delivers easy-to-use and fully automated site-to-site network connectivity between any site
3. Designed for both SMB and enterprise customers, as well as service providers
Here is another picture from Veeam PN user guide:

![image](https://user-images.githubusercontent.com/106635733/207789750-7feb6230-01e1-43cf-961b-1484ffc4a36e.png)

**Veeam PN System Requirements:**
**1. Network Hub:**
  whether installed At Azure or On-premises (for site-to-site scenario) needs to run on at least ESXi/vSphere 5.0 or higher (hardware version 8 or later), needs 1Gb of RAM. For “point-to-site” scenario you need Microsoft Azure account in order to be able to set up an A1 VM at least (1 core, 1.75 GB memory, 70 GB of disk space).

**2.Site Gateway:**
 The on-premise part also called Site Gateway is an appliance which has a disk size of 3.9Gb (thin provisioned) or 16Gb thick.
Veeam has an online user guide for Veeam PN where you can follow the different configuration steps or how-tos.

Check it out here.
- Few other fellow bloggers, including Anthony Spiteri at Veeam blog (link below), has already written about Veeam PN. As being said, the product is now GA, so go and download your copy to test it out.
- Veeam PN enables organizations to use Microsoft Azure for restoring their data and ensure business continuity without the need for a dedicated recovery site. If you have a remote site, you won't need Azure.

**Sum-up:**
It also simplifies the configuration and deployment of the restoration site with the new Veeam PN (Powered Network), which is a complete networking solution. You can also use Veeam PN for easy migrations of your local workloads into Microsoft Azure.

**Tham khảo hướng dẫn cài VeeamPN:**
https://thangletoan.wordpress.com/2021/08/16/cai-va-cau-hinh-openvpn-va-wire-guard-tren-ubuntu-server-18-04-dap-ung-nhu-cau-wfh/


**Link Download VeeamPN OVA (Virtual Machine):**
https://1drv.ms/u/s!AtT2yQnThe-ykLYa3oyYiYyPk5Pp6A?e=HtPWlU

#  Phần 2. Cloud VPN Gateway:
**Xây dựng lại VPN Enterprise for BaaS, Console, Control DC**
   Install and Configure Pritunl VPN server on Ubuntu 20.04
In our guide today, we are looking at how to install Pritunl VPN server on Ubuntu 20.04. Pritunl VPN is an opensource VPN server and management system. It utilizes a graphical interface that is friendly and easy to use to the user. It is secure and provides a good alternative to the commercial VPN products. It has the ability to create a wide range of cloud vpn networks which can support over a thousands of users.

**Features of Pritunl VPN:**
Below are the most notable features of Pritunl VPN that makes it an option for many:

1. Simple to install and configure
2. Supports multi-cloud VPN peering
3. Offers upto five layers of authentication making it more secure.
4. Supports Wireguard, giving clients theoption to connect with openvpn or Wireguard
5. Quickly and easily scale to thousands of users, having high availability in the cloud environment without the need for expensive proprietary hardware
    supports all OpenVPN clients with official clients for most devices and platforms.
6. Create multi-cloud site-to-site links with VPC peering. VPC peering available for AWS, Google Cloud, Azure and Oracle Cloud.
7. Interconnect AWS VPC networks across AWS regions and provide reliable remote access with automatic failover that can scale horizontally
8. Pritunl is built on MongoDB, a reliable and scalable database that can be quickly deployed

**Pritunl VPN Architecture Review:**
Pritunl VPN presents an distributed and scalable infrastructure that quickly and easily scale to thousands of users, having high availability in the cloud environment without the need for expensive proprietary hardware. It works on server-client architecture, where servers and users are configured on the VPN server and clients profiles are downloaded to be used on the clients.
Pritunl is built on MongoDB, a reliable and scalable database that can be quickly deployed. With built in support for replication a reliable database can be setup in minutes making a Pritunl cluster deployment fast and easy.

![image](https://user-images.githubusercontent.com/106635733/208446860-c3a5bcf6-600d-4e5b-81c0-76fdec869ac2.png)
Installing Pritunl VPN server on Ubuntu 20.04 To install Pritunl VPN server on Ubuntu 20.04, we are going to follow a number of steps as stated below:
wget https://raw.githubusercontent.com/PhDLeToanThang/veeambackup/master/vpnenterprise.sh && bash ./vpnenterprise.sh

