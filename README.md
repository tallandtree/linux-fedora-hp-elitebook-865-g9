# Getting Fedora configured on HP EliteBook 865 G9

Displaylink is fixed withkKernel `6.2.7-200.fc37.x86_64`:
https://github.com/displaylink-rpm/displaylink-rpm/issues/235
If broken again, fix this as follows:
Fix by reverting kernel to previous version:
https://docs.fedoraproject.org/en-US/quick-docs/kernel/booting/

## Preperation
You need to have ansible installed on the machine you run the playbook from

``` /bin/bash
sudo apt install ansible -y
git clone https://github.com/tallandtree/linux-fedora-hp-elitebook-865-g9.git
cd Fedora-book
```

Also make sure to edit the variables inside hosts inventory file:
``` yaml
[fedora:vars]
ansible_user= < paste-your-username >
trusted_cert= <pasted trusted vpn cert > 
vpn_address= <paste vpn url> 

[fedora]
<mylaptop-name> ansible_host=<mylaptop-name.fullyqualified> ansible_connection=local

```
You can generate the hosts file as follows:

``` /bin/bash
$ ./gen_hosts.sh -f <fully qualified hostname> -u <username> -v <vpn_address> -t <trusted_cert>
```

Turn off your Security Boot in BIOS

## Password vault

This playbook depends on the existence of a password vault with the users password in the vault.
You can create the vault as follows:

``` /bin/bash
$ ansible-vault create passwd.yml
```
And then add you edit the vault by:
``` /bin/bash
$ ansible-vault edit passwd.yml
```
Add your password to the vault in yaml syntax:
``` /bin/bash
sudo_password: <my password>
```

## Applying the configuration

If you are on the machine you want to configure:
``` /bin/bash
ansible-playbook -i hosts -l <host> --become --ask-vault-pass --extra-vars '@passwd.yml' --extra-vars new=true main.yml
```
To update the packages and recompile the wifi drivers:
``` /bin/bash
ansible-playbook -i hosts -l <host> --become --ask-vault-pass --extra-vars '@passwd.yml' --extra-vars update=true main.yml
```
To install the tools:
``` /bin/bash
ansible-playbook -i hosts -l <host> --become --ask-vault-pass --extra-vars '@passwd.yml' --extra-vars tools=true main.yml
```

## Also:

To use forty vpn config:
``` /bin/bash
sudo openfortivpn -c ~/forti_config
```

## Post configurations (not yet automated)

Configure Follow-Me CCV Printer:
Open Cups Printer, add a new printer, select lpd, and enter the printer URL:

Select the driver "Ricoh MP C3003 - CUPS+Gitenprint v5.3.4 Simplified (EN) and print a test page to find out the printer is correctly configured.
For the Follow-Me printer to work, your local username must match your CCVEU username.
