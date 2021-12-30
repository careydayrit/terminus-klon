# Author: Carey Dayrit
# Author URL : https://careydayrit.com

FROM ubuntu:focal

# install the ssh service
RUN apt update && apt install  software-properties-common openssh-server sudo -y 

# install php dependency
RUN add-apt-repository ppa:ondrej/php -y && apt update
RUN apt-get install curl php7.4 php7.4-curl php7.4-cli php7.4-mbstring php7.4-xml git unzip vim -y

# install composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --filename=composer
RUN mv composer /usr/local/bin/composer

WORKDIR '/terminus'

# install terminus
RUN composer require pantheon-systems/terminus
RUN ln -s /terminus/vendor/pantheon-systems/terminus/bin/terminus  /usr/local/bin/terminus

# run ssh as a service to keep the container running
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test 

RUN  echo 'test:test' | chpasswd

RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
