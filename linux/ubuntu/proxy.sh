#This is an example file which help to configure the company proxy
#!/bin/bash 
export proxy="10.X.X.X"
export proxy_port="80"
export proxy_user="mydoum"
export proxy_password="XXXX"
export no_proxy="localhost,127.0.0.1"

# In this configuration, http and https have the same url
export http_proxy="http://$proxy_user:$proxy_password@$proxy:$proxy_port"
export https_proxy="http://$proxy_user:$proxy_password@$proxy:$proxy_port"
export ftp_proxy="http://$proxy_user:$proxy_password@$proxy:$proxy_port"

# Configuration du proxy pour apt-get
echo "Acquire::http::proxy $http_proxy;" >> /etc/apt/apt.conf.d/95proxies 
echo "Acquire::https::proxy $https_proxy;" >> /etc/apt/apt.conf.d/95proxies 
echo "Acquire::ftp::proxy $ftp_proxy;" >> /etc/apt/apt.conf.d/95proxies

# Disable the firewall
sudo ufw disable
