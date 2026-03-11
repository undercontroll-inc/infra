#!/bin/bash
set -e

apt-get update -y
apt-get install -y nginx

useradd --system --shell /bin/bash --home /home/deploy --create-home deploy

mkdir -p /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
echo "${deploy_public_key}" > /home/deploy/.ssh/authorized_keys
chmod 600 /home/deploy/.ssh/authorized_keys
chown -R deploy:deploy /home/deploy/.ssh

chown -R deploy:deploy /usr/share/nginx/html

# Remove the default nginx site that ships with Ubuntu so it does not conflict
# with the custom server block deployed by the CD pipeline.
rm -f /etc/nginx/sites-enabled/default

echo "deploy ALL=(ALL) NOPASSWD: \
  /usr/sbin/nginx -t, \
  /usr/sbin/nginx -s reload, \
  /usr/bin/tee /etc/nginx/conf.d/default.conf, \
  /bin/rm -f /etc/nginx/sites-enabled/default" \
  > /etc/sudoers.d/deploy-nginx
chmod 440 /etc/sudoers.d/deploy-nginx

sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl reload sshd

systemctl enable nginx
systemctl start nginx
