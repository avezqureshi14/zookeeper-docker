# Use OpenJDK base image
FROM openjdk:8-jre

# Set ZooKeeper version
ENV ZK_VERSION=3.9.3

# Install ZooKeeper, Node.js, and NGINX
RUN apt-get update && apt-get install -y wget nginx curl \
    && wget https://downloads.apache.org/zookeeper/zookeeper-$ZK_VERSION/apache-zookeeper-$ZK_VERSION-bin.tar.gz \
    && tar -xzf apache-zookeeper-$ZK_VERSION-bin.tar.gz \
    && mv apache-zookeeper-$ZK_VERSION-bin /opt/zookeeper \
    && rm apache-zookeeper-$ZK_VERSION-bin.tar.gz \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Create required directories for ZooKeeper
RUN mkdir -p /tmp/zookeeper

# Set working directory for ZooKeeper
WORKDIR /opt/zookeeper

# Copy ZooKeeper configuration
COPY zoo.cfg /opt/zookeeper/conf/zoo.cfg

# Copy NGINX configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Add proxy server code
WORKDIR /proxy
COPY proxy/ /proxy

# Install dependencies for the proxy server
RUN cd /proxy && npm install

# Expose HTTP port
EXPOSE 80

# Start NGINX, ZooKeeper, and the proxy server
CMD service nginx start && /opt/zookeeper/bin/zkServer.sh start-foreground & node /proxy/server.js
