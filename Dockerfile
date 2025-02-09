# Use OpenJDK base image
FROM openjdk:8-jre

# Set ZooKeeper version
ENV ZK_VERSION=3.9.3

# Install ZooKeeper and NGINX
RUN apt-get update && apt-get install -y wget nginx \
    && wget https://downloads.apache.org/zookeeper/zookeeper-$ZK_VERSION/apache-zookeeper-$ZK_VERSION-bin.tar.gz \
    && tar -xzf apache-zookeeper-$ZK_VERSION-bin.tar.gz \
    && mv apache-zookeeper-$ZK_VERSION-bin /opt/zookeeper \
    && rm apache-zookeeper-$ZK_VERSION-bin.tar.gz

# Create required directories
RUN mkdir -p /tmp/zookeeper

# Set working directory
WORKDIR /opt/zookeeper

# Copy default configuration
COPY zoo.cfg /opt/zookeeper/conf/zoo.cfg

# Copy NGINX configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose HTTP port
EXPOSE 80

# Start NGINX and ZooKeeper
CMD service nginx start && bin/zkServer.sh start-foreground
