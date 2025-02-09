# Use OpenJDK base image
FROM openjdk:8-jre

# Set ZooKeeper version
ENV ZK_VERSION=3.9.3

# Install ZooKeeper
RUN apt-get update && apt-get install -y wget \
    && wget https://downloads.apache.org/zookeeper/zookeeper-$ZK_VERSION/apache-zookeeper-$ZK_VERSION-bin.tar.gz \
    && tar -xzf apache-zookeeper-$ZK_VERSION-bin.tar.gz \
    && mv apache-zookeeper-$ZK_VERSION-bin /opt/zookeeper \
    && rm apache-zookeeper-$ZK_VERSION-bin.tar.gz

# Set working directory
WORKDIR /opt/zookeeper

# Expose the default ZooKeeper port
EXPOSE 2181

# Copy default configuration
CMD ["bin/zkServer.sh", "start-foreground"]
