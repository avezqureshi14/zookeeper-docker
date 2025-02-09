const express = require('express');
const zookeeper = require('node-zookeeper-client');

// Replace with your ZooKeeper connection string
const zkConnectionString = 'localhost:2181'; // Inside Docker, ZooKeeper runs on localhost

// Initialize the Express app
const app = express();
app.use(express.json());

// Connect to ZooKeeper
const zkClient = zookeeper.createClient(zkConnectionString);

zkClient.on('connected', () => {
    console.log('Connected to ZooKeeper');
});

// Start the ZooKeeper connection
zkClient.connect();

// Endpoint to create a node
app.post('/create', (req, res) => {
    const { path, data } = req.body;

    zkClient.create(path, Buffer.from(data || ''), (err) => {
        if (err) {
            res.status(500).json({ error: err.message });
        } else {
            res.json({ message: `Node created at ${path}` });
        }
    });
});

// Endpoint to get node data
app.get('/get', (req, res) => {
    const { path } = req.query;

    zkClient.getData(path, (err, data) => {
        if (err) {
            res.status(500).json({ error: err.message });
        } else {
            res.json({ path, data: data.toString() });
        }
    });
});

// Endpoint to delete a node
app.delete('/delete', (req, res) => {
    const { path } = req.body;

    zkClient.remove(path, (err) => {
        if (err) {
            res.status(500).json({ error: err.message });
        } else {
            res.json({ message: `Node deleted at ${path}` });
        }
    });
});

// Start the proxy server
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
    console.log(`Proxy server is running on port ${PORT}`);
});
