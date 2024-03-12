#!/bin/bash
sudo yum update -y
sudo yum install -y java-1.8.0-amazon-corretto-devel

JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
echo "JAVA_HOME=\"$JAVA_HOME\"" | sudo tee -a /etc/environment

wget https://downloads.apache.org/spark/spark-3.5.1/spark-3.5.1-bin-hadoop3.tgz
tar xvf spark-3.5.1-bin-hadoop3.tgz
sudo mv spark-3.5.1-bin-hadoop3 /opt/spark