#!/bin/bash


installMaven() {
  cd $HOME/softwares/dist
  curl -O https://dlcdn.apache.org/maven/maven-3/3.9.8/binaries/apache-maven-3.9.8-bin.tar.gz
  tar -xvf apache-maven*.tar.gz
  ln -s $HOME/softwares/dist/apache-maven-3.9.8 $HOME/softwares/maven
}

installMaven