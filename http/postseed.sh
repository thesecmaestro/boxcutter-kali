#!/bin/bash
mkdir -p /root/.ssh
# Replace "YOUR SSH KEY" with a your ssh public key.
echo "YOUR SSH KEY" > /root/.ssh/authorized_keys
# Disable SSH password authentication
sed 's/#PasswordAuthentication\ yes/PasswordAuthentication\ no/g' /etc/ssh/sshd_config

# Set the admin password of OpenVas to admin123
sed '/add_user/ s|$| -w admin123|' /usr/bin/openvas-setup
/usr/bin/openvas-setup
rm -rf /etc/rc.local

cat << EOF > /etc/rc.local
#!/bin/bash
/etc/init.d/greenbone-security-assistant start
/etc/init.d/openvas-scanner start
/etc/init.d/openvas-administrator start
/etc/init.d/openvas-manager start
# Set msfrpcd to username "metadmin" and password "metpass123" on port 1337
/usr/bin/msfrpcd -S -U metadmin -P metpass123 -p 1337 &

exit 0
EOF

chmod 755 /etc/rc.local

update-rc.d ssh enable
update-rc.d postgresql enable
update-rc.d metasploit enable
