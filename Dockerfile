FROM ubuntu:16.04

MAINTAINER Dainis Lapins <dainis186@gmail.com>

# Elixir requires UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# update and install some software requirements
RUN apt-get update && apt-get dist-upgrade -y \
&& apt-get install -y apt-utils curl wget git make imagemagick htop vim xvfb xz-utils erlang-xmerl

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y yarn

# Install wkhtmltopdf
RUN wget http://download.gna.org/wkhtmltopdf/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
RUN tar -xf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
RUN ls
RUN cp -a ./wkhtmltox/. /usr/

# install Node.js (>= 6.0.0) and NPM in order to satisfy brunch.io dependencies
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash
RUN apt-get install -y nodejs

# download and install Erlang package
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
 && dpkg -i erlang-solutions_1.0_all.deb \
 && apt-get update -y

# install latest elixir package
RUN apt-get install -y elixir erlang-dev erlang-parsetools && rm erlang-solutions_1.0_all.deb

# Install last hex
RUN mix local.hex && mix local.rebar

# install the Phoenix Mix archive
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez

RUN apt-get -y autoremove
RUN apt-get -y autoclean
RUN wkhtmltopdf -V
RUN elixir -v
WORKDIR /code
