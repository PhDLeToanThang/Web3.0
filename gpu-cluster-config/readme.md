.. -*- rst -*-

GPU Cluster Configuration Notes
===============================

Introduction
------------
This document contains notes on configuring a cluster of machines with NVIDIA 
GPUs running Ubuntu Linux 14.04 or later on a private network connected to a 
single master host that serves as the cluster's network gateway, file server, 
and name service master. `SLURM <http://slurm.schedmd.com>`_ is used for job 
management, `OpenLDAP <http://www.openldap.org>`_ is used for name service 
management, and the existence of an externally managed Kerberos KDC is assumed
for managing user authentication.

The sections of this document are not necessarily listed in a prescribed order,
nor does the document attempt to provide all information necessary for obtaining
an optimal cluster configuration. Feel free to submit suggestions/corrections as
pull requests to `the source repository <https://github.com/neurokernel/gpu-cluster-config>`_.

The author categorically disclaims all responsibility for any adverse effects to
your data center that may ensue as a result of following these instructions. :-)

Author & License
----------------
.. image:: https://i.creativecommons.org/l/by/4.0/88x31.png
    :target: http://creativecommons.org/licenses/by/4.0/
    :alt: http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License

This work by Lev Givon is licensed under a 
`Creative Commons Attribution 4.0 International License <http://creativecommons.org/licenses/by/4.0/>`_

General System Configuration
----------------------------
- After installing Ubuntu, it's possible that the system's console might not 
  work because of misinteraction with the ``nouveau`` open source NVIDIA driver.  
  To fix this, login to the machine over the network with ssh and blacklist the 
  driver by adding a file to ``/etc/modprobe.d/`` containing the line ::

      blacklist nouveau
  
  Recent NVIDIA CUDA packages should automatically do the above during 
  installation, however.

- Add ``umask 0077`` to ``/etc/bash.bashrc`` *before* creating any user accounts 
  to enforce more private default file creation permissions.
- When creating user accounts, check that the created home directory and the 
  various files created by default (e.g., ``.bashrc``, ``.profile``, etc.) are 
  not world readable.
- If the master host contains an IPMI or BMC device for remote management 
  exposed to the Internet, have your network administrator assign it a static IP 
  address and *remember to set an administrator password*.  The latter can 
  typically be done through the web or via ``ipmitool``.
- The IPMI devices of the remote management interfaces on the internal
  network do not need any passwords (the default username and password -
  ``ADMIN`` - can remain unchanged).
- To upgrade Ubuntu from the command line, install ``update-manager-core``, edit
  ``/etc/update-manager/release-upgrades``, and run ``do-release-upgrade``
  as root.

Configuring Networking
----------------------
- The below instructions assume that the worker nodes have private addresses in 
  the 192.168.0.0/16 subnet.
- Activate ``ufw`` on the master host and deactivate it on the worker hosts.
- Leave the OpenSSH port on the master host open.
- Update ``/etc/default/ufw`` to contain the line ::

	 DEFAULT_FORWARD_POLICY="ACCEPT"

- Update ``/etc/ufw/sysctl.conf`` to contain the lines ::

     net/ipv4/ip_forward=1
     net/ipv6/conf/default/forwarding=1
     net/ipv6/conf/all/forwarding=1

- Add the following lines to the top of ``/etc/ufw/before.rules`` (replace the
  multicast address as appropriate for the private network and the interface
  with whichever interface the gateway uses to communicate with the outside
  world)::

     * nat
	 :POSTROUTING ACCEPT [0:0]
	 -A POSTROUTING -s 192.168.0.0/8 -o eth0 -j MASQUERADE
	 COMMIT
- Add the following rules::

     ufw allow to 192.168.0.0/16
     ufw allow from 192.168.0.0/16

- After making the above modifications, restart ``ufw``::

     ufw disable && ufw enable
- Install ``avahi-daemon`` on the master and configure avahi on all of the
  nodes (including the master) to assign a private hostname. This
  should only involve modifying the ``host-name`` and ``domain-name``
  options in ``/etc/avahi/avahi-daemon.conf``
- On the master, make sure that avahi only announces the private hostname on the
  internal Ethernet interface associated with the private network by setting the
  ``allow-interfaces`` option in ``/etc/avahi/avahi-daemon.conf`` accordingly.
- Put the hostname of each worker in its respective
  ``/etc/sysconfig/network`` file, e.g., ::

     HOSTNAME=node02.local
- Add all of the worker host names and IP addresses to ``/etc/hosts`` on the 
  master, e.g.::

     192.168.0.1 node01.local    node01
     192.168.0.2 node02.local    node02
     192.168.0.3 node03.local    node03
     192.168.0.4 node04.local    node04
     192.168.0.5 node05.local    node05

- Install ``isc-dhcp-server`` on the master and configure it to
  assign static private IP addresses to the workers; see the accompanying
  `dhcpd.conf <dhcpd.conf>`_ file for an example.
- If the machines have IPMI devices on the same physical Ethernet
  ports that are connected to the private network, make sure that they
  are assigned their own IP addresses via DHCP. It may be necessary to
  manually clear the IP address associated with the IPMI device in the
  machine's BIOS.
- Ostensibly, it is possible to use ``ipmitool`` to set the IPMI device
  LAN Select setting on SuperMicro motherboards (see `this page
  <http://www.supermicro.com/support/faqs/faq.cfm?faq=9848>`_ for more 
  information).
- To configure password-less login from any machine in the cluster to
  the other for all non-root users, make sure that ``/etc/ssh/ssh_config``
  on all of the machines contains the following lines: ::

     HostbasedAuthentication yes
     EnableSSHKeysign yes

  To reduce latency, it is advisable to include the following lines::

     Compression no
     Ciphers blowfish-cbc
- ``/etc/ssh/shots.equiv`` on all of the nodes should contain the private
  names of each of the nodes.
- ``/etc/ssh/ssh_known_hosts`` needs to contain the public host key for each
  host that one wishes to connect to; the host name and IP address need to be
  included as well.
- To enable password-less login for root on the private nodes,

  - create a ``/root/.shosts`` file that contains the private
    names of all of the machines in the cluster and make sure that
    ``/etc/ssh/sshd_config`` on each node contains the following option::

     IgnoreRhosts no
  - create public keys for the root user with no passphrase and dump the public
    keys into ``/root/.ssh/authorized_keys`` on each host
  - set ``PermitRootLogin without-password`` in ``/etc/ssh/sshd_config``
    on all of the hosts

Setting up NFS
--------------
- Install ``nfs-server`` on the master and ``nfs-client`` on the worker hosts.
- To export the home directories on the master node, make sure that the line ::

     NEED_IDMAPD=yes

  is in ``/etc/default/nfs-common`` on both the master and client hosts.
- On the master, create a directory called ``/srv/nfs4/home`` on the
  master node, set its permissions to 755, and mount ``/home`` on it
  using the command ::

     mount --bind /home /srv/nfs4/home

  Modify the master's ``/etc/fstab`` file to contain ::

     /home /srv/nfs4/home none bind 0 0
- Modify ``/etc/exports`` on the master to contain ::

     /srv/nfs4      192.168.0.0/24(rw,fsid=0,nohide,no_subtree_check,no_root_squash)
     /srv/nfs4/home 192.168.0.0/24(rw,nohide,no_subtree_check,no_root_squash)

- Run ``exportfs -a`` on the master to export ``/srv/nfs4/home`` to the clients.
  Run ``showmount -e 192.168.0.1`` on the clients to confirm that they can see 
  the master's export list.

- Create the directory ``/mnt/server-home`` on the clients and modify
  their ``/etc/fstab`` files to contain ::

     192.168.0.1:/home /mnt/server-home nfs4 auto,_netdev,hard,intr 0 0
- Move ``/home`` to ``/local-home`` on all of the clients and create a link from
  ``/home`` to ``/mnt/server-home``; mount ``/mnt/server-home`` on all of
  the clients.
- It may be possible to improve NFS performance by adjusting network interface 
  settings and mount parameters. See `this page 
  <http://www.slashroot.in/how-do-linux-nfs-performance-tuning-and-optimization>`_ 
  for more information
  
Setting up LDAP
---------------
- Install ``openldap-servers`` and ``openldap-clients`` on the master.
- Use ``dpkg-reconfigure`` to reconfigure LDAP on Ubuntu. The default domain
  and base don't need to be changed.
- Make sure that ``/etc/nsswitch.conf`` is configured to
  look at ldap after files when looking up password, shadow, or group data::

     passwd:         files ldap [NOTFOUND=return] db
     group:          files ldap [NOTFOUND=return] db
     shadow:         files ldap [NOTFOUND=return] db
- If there is a need to reinstall the OS, the contents of the LDAP database
  can be dumped into an ldif format file using ``slapcat`` and loaded
  into the new server's database using something like ::

     ldapadd -v -x -W -D "cn=admin,o=nodomain" -c -f old.ldif

  where the domain is whatever is associated with
  the LDAP administrator.

Installing libuser
------------------
- ``libuser`` provides command-line tools for managing user accounts. Since the
  stock Ubuntu package isn't compiled with LDAP support, however, it needs to
  be manually built and installed as follows.
- Install ``libsasl-dev``, ``libpython2.7-dev``, ``libldap-dev``, 
  ``libpopt-dev``, and ``libpam-dev``. Make sure that the stock ``libuser1`` 
  package is *not* installed.
- `Download <https://fedorahosted.org/libuser/>`_ the latest ``libuser`` source, 
  unpack, and build as follows::

     ./configure --prefix=/usr/local --with-ldap=/usr/include \
     --with-popt=/usr/include --with-sasl=/usr/include
     make CFLAGS=-I/usr/include
     make install
- Update ``/usr/local/etc/libuser.conf`` to set the lines in the associated
  sections (replace the ``basedn``, ``binddn``, and ``password`` values as
  needed); also ensure that it is only readable by root. ::

     [defaults]
     modules = ldap
     create modules = ldap

     [ldap]
     server = ldap://127.0.0.1
     basedn = dc=nodomain

     binddn = cn=admin,dc=nodomain
     password = mypassword
     bindtype = simple
- Try adding a user using ``/usr/local/sbin/luseradd`` as root. If everything
  works properly, the new user should appear in the output of ``slapcat``.
- Remember to add the Unix account used to administer the master machine to
  LDAP with ``luseradd`` - specify the existing uid, group, and home directory
  so that new ones are not created.

Setting up Kerberos Authentication
----------------------------------
- Install the ``krb5-workstation`` package on the master server and configure 
  ``/etc/krb5.conf`` to refer to the appropriate KDC. The `accompanying 
  <krb5.conf>`_ ``krb5.conf`` file is specific to Columbia University.
- Install ``pam-krb5``. Note that this is the module used by Debian,
  not by RedHat.
- After installing ``pam-krb5``, it may be necessary to adjust the
  ``minimum_uid`` parameter in the pam configuration files.
- Add ``.k5login`` files to the users' directories containing the appropriate
  principal. For Columbia University, this should be ``abc123@CC.COLUMBIA.EDU``
  (where ``abc123`` is the CUIT-assigned UNI of the user in question) to enable
  users to access the machine using the Kerb password associated with their UNI.
- Add users authorized to access the machine to the ``AllowUsers`` line in
  ``/etc/ssh/sshd_config``.
- To store the password of an account locally in ``/etc/shadow`` (e.g., to
  ensure that the user can login even if Kerberos or LDAP are not functioning),

  - temporarily disable Kerberos and LDAP authentication using
    ``pam-auth-update``,
  - create a temporary local password using
    ``mkpasswd -m sha-512 -S somesaltstring -s <<< TempPassword``
  - add a line for the account to ``/etc/passwd`` with ``vipw``
    and a line containing the encrypted password to ``/etc/shadow`` with
    ``vipw -s``,
  - modify the password to whatever the user wants using ``/usr/bin/passwd``,
  - update the account's local groups if so desired by editing ``/etc/group``
    using ``vigr`` and ``vigr -s``, and
  - re-enable Kerberos and LDAP authentication using ``pam-auth-update``.
  
Installing CUDA
---------------
- Ubuntu provides its own NVIDIA GPU driver and CUDA packages. Although you can 
  use them, the ones provided by NVIDIA are usually more up to date; read on if 
  you want to use them.
- For versions of Ubuntu for which a ``.deb`` package is available:
  
  - Download and install the "deb (network)" Ubuntu package from NVIDIA's 
    `website <https://developer.nvidia.com/cuda-downloads>`_.
  - After refreshing the system's package information using ``apt-get update``, 
    install the ``cuda-VERSION`` metapackage (e.g., ``cuda-7-5``) to install all 
    of the requisite drivers and libraries. Reboot the machine after 
    installation.
- For more recent versions of Ubuntu for which no ``.deb`` package is available 
  (e.g., Ubuntu 16.04 as of April 2016):

  - Ensure that the most recent NVIDIA kernel drivers are installed; you can 
    find them by installing ``aptitude`` and running the command ``aptitude 
    search nvidia``
  - Download and install the "runfile (local)" file from NVIDIA's
    `website <https://developer.nvidia.com/cuda-downloads>`_ for the most recent 
    release of Ubuntu.
  - Make the file executable and run it with the ``--override`` option.
  - When prompted by the installer as to whether to install the "Accelerated 
    Graphics Driver", enter ``n``.
  - Install the CUDA software in ``/usr/local/cuda-VERSION`` with a link from
    ``/usr/local/cuda`` to that directory, where ``VERSION`` is the version of 
    CUDA being installed.
  - After installation is complete, ensure that that all of the contents of
    the ``/usr/local/cuda-VERSION`` directory are world-readable (and executable 
    where appropriate).
  - Create a file named ``/etc/profile.d/cuda.sh`` containing the line
    ``export PATH=$PATH:/usr/local/cuda/bin``
  - Create a file named ``/etc/ld.so.conf.d/cuda.conf`` containing the line
    ``/usr/local/cuda/lib64``
  - Run the command ``sudo source /etc/profile.d/cuda.sh``
  - Run the command ``sudo ldconfig``
- If the ``/dev/nvidia*`` devices fail to initialize when the machine boots and
  there appears to be a kernel module error in the output of ``dmesg``, try
  installing a more recent version of the device drivers (you may need to obtain
  it from a `third party ppa 
  <https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa>`_).
- Ensure that ``nvidia-persistenced`` has been installed and is
  running - this will keep GPUs warm so as to avoid delays in startup. On Ubuntu
  16.04, it may be necessary to create a startup script manually; see the
  ``init`` subdirectory in `this repo <https://github.com/NVIDIA/nvidia-persistenced>`_ for details.
- Add ``/usr/local/cuda/bin`` to ``PATH`` in ``/etc/bash.bashrc`` so that all 
  users can access the CUDA binaries without having to modify their own 
  ``.bashrc`` scripts.
- On Ubuntu 16.04, comment out the line that contains the following text in the 
  file
  ``/usr/local/cuda-7.5/include/host_config.h``::

     #error -- unsupported GNU version! gcc versions later than ... not 
     supported!
  using a C++ line comment symbol (``//``) so that CUDA works properly with gcc 
  5.  
  
Configuring SLURM
-----------------
- Install ``slurm-llnl`` and ``munge`` on all hosts.
- Generate a MUNGE key on the master by running ``create-munge-key``.
- Modify various directory/file permissions as indicated in the `MUNGE Wiki 
  <https://github.com/dun/munge/wiki/Installation-Guide>`_.
- On Ubuntu 14.04, update ``/etc/default/munge`` to circumvent `this bug 
  <https://code.google.com/p/munge/issues/detail?id=31>`_.
- For Ubuntu 15.04 or later, see `this issue <https://github.com/dun/munge/issues/35>`_.
- Copy the MUNGE key on the master to ``/etc/munge`` on the worker hosts.
- Start MUNGE using ``service munge start``
- Install the accompanying `slurm.conf <slurm.conf>`_ and `gres.conf 
  <gres.conf>`_ files to ``/etc/slurm-llnl``; modify both files as appropriate.
  To find the number of CPUs (or hyperthreads, if supported), sockets, cores per socket,
  and threads per core, run the ``lscpu`` utility; to find the GPU device files 
  to list in ``gres.conf``, run ``ls -l /dev/nvidia?``.
- Note that ``slurm.conf`` must be the same on all nodes, but ``gres.conf`` 
  should be customized in accordance with the actual number of GPUs on a host.
- On Ubuntu 16.04, it may be necessary to include the following lines in 
  ``slurm.conf``::

     SelectType=select/cons_res
     SelectTypeParameters=CR_CPU_Memory
- Run ``update-rc.d slurm-llnl enable`` to ensure that SLURM starts on reboot.
  On Ubuntu 14.04, it may be necessary to restart SLURM manually after a reboot 
  if GPU initialization does not complete before the system tries to start 
  SLURM.
- To prevent users on the master node from accessing any GPUs on that machine
  without using SLURM, include the following in ``/etc/bash.bashrc`` ::

    export CUDA_VISIBLE_DEVICES=