#summary How to configure your systems to use ssh_get_by_ssh.php

This document explains how to prepare systems for graphing with the SSH-based scripts, which use only standard SSH and Unix commands to gather data from servers.  The example server I want to graph is 192.168.1.107.

The high-level process is as follows:

  # Set up an SSH keypair for SSH authentication.
  # Create a Unix user on each server you want to graph.
  # Install the public key into that user's authorized_keys file.
  # Install and configure the PHP file.
  # Test the results.

= Creating an SSH Key Pair =

After importing the desired template, which is covered in the template-specific documentation, the next thing to do is set up SSH keys for the poller process to use.  To do this, I need to know what user the Cacti poller runs as.  I can look in the cron job that runs the poller:

{{{
debian:~# grep -r cacti /etc/cron*
/etc/cron.d/cacti:*/5 * * * * www-data php /usr/share/cacti/site/poller.php >/dev/null 2>/var/log/cacti/poller-error.log
}}}

Another way is to simply look at who owns the log files:

{{{
debian:~# ls -l /var/log/cacti/
total 68
-rw-r----- 1 www-data www-data 53816 2009-10-27 17:55 cacti.log
-rw-r----- 1 www-data www-data  7120 2009-10-25 06:20 cacti.log.1.gz
-rw-r--r-- 1 www-data www-data     0 2009-10-27 17:55 poller-error.log
-rw-r----- 1 www-data www-data     0 2009-10-19 18:57 rrd.log
}}}

In both cases, I can see that it runs as www-data.  I'll need to keep this in mind as I set things up further.

Now I will create an SSH key pair without a passphrase.  When ssh-keygen asks me where to save the key, I will specify a convenient location.  For example, I am using a Debian server here, and Debian keeps the Cacti configuration in /etc/cacti, which seems like a better place than /var/www (the www-data user's default home directory).

{{{
debian:~# ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): /etc/cacti/id_rsa
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /etc/cacti/id_rsa.
Your public key has been saved in /etc/cacti/id_rsa.pub.
}}}

The key has been created with permissions that will not let the www-data user access it, and I need to fix that.

{{{
debian:~# chown www-data /etc/cacti/id_rsa*
debian:~# ls -l /etc/cacti/
total 16
-rw-r--r-- 1 root     root      539 2008-08-08 21:43 apache.conf
-rw-r----- 1 root     www-data  575 2009-10-20 16:23 debian.php
-rw------- 1 www-data root     1675 2009-10-27 18:07 id_rsa
-rw-r--r-- 1 www-data root      393 2009-10-27 18:07 id_rsa.pub
}}}

That should work fine.

= Creating the User =

Now I'll create the user on the server I want to graph.  For this example, I'll call this user "cacti".  Remember, the server I want to graph is 192.168.1.107.

For this example, I'm going to create the user manually and give it a suitable password, but you can create the user however you please.

{{{
debian:~# ssh 192.168.1.107 adduser cacti
Adding user `cacti' ...
...
}}}

= Installing the Public Key =

Once the user is created, I'm ready to copy the SSH key into its home directory:

{{{
debian:~# ssh-copy-id -i /etc/cacti/id_rsa.pub cacti@192.168.1.107
cacti@192.168.1.107's password: 
Now try logging into the machine, with "ssh 'cacti@192.168.1.107'", and check in:

  .ssh/authorized_keys

to make sure we haven't added extra keys that you weren't expecting.

debian:~# ssh -i /etc/cacti/id_rsa cacti@192.168.1.107 echo "it works"
it works
}}}

Notice that I copied the public key (id_rsa.pub) and then logged in with the private key (id_rsa).

= Installing and Configuring the PHP Script =

I should now be ready to use the PHP script to connect to this server over SSH.  All I need to do is copy ss_get_by_ssh.php to the Cacti script directory and set the proper configuration variables.  I'll do it with an external configuration file, but you can do it any way you please:

{{{
debian:~# cp mysql-cacti-templates/scripts/ss_get_by_ssh.php /usr/share/cacti/site/scripts/
debian:~# cat > /usr/share/cacti/site/scripts/ss_get_by_ssh.php.cnf
<?php
$ssh_user   = 'cacti';
$ssh_iden   = '-i /etc/cacti/id_rsa';
?>
CTRL-D
}}}

If you need a more complex configuration setup, such as connecting to a different SSH port on different servers, use the instructions at [CustomizingTemplates#Accept_Input_in_Each_Data_Source].

= Testing the Setup =

Finally, I'll test the script to see if it can connect and retrieve values.  It is important to do this as the same user the crontab runs under, with an empty environment, just as the crontab does.  Otherwise the results will not necessarily indicate anything about whether Cacti's polling will succeed or fail!  The sample call to the script that follows is a good example.  Make sure you specify the correct username; here I am using www-data.  If the resource you're graphing runs on a non-standard port, use the --port2 option.

{{{
debian:~# su - www-data -c 'env -i php /usr/share/cacti/site/scripts/ss_get_by_ssh.php --type memory --host 192.168.1.107 --items au,av'
au:30842880 av:2244608
debian:~# 
}}}

In the example above, the script did not print a newline after its output, so the next prompt is a bit messed up, but the output is "au:30842880 av:2244608", followed by the command prompt, "debian:~# ".

Everything looks fine, so the graphing should be working!  Continue with the template-specific documentation.