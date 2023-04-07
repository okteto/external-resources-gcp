const express = require('express')
const {PubSub} = require('@google-cloud/pubsub');
const projectId = process.env.GCP_PROJECT_ID;
const topicName = process.env.TOPIC;
const pubsub = new PubSub({projectId});

const app = express()
app.use(express.json());
app.use(express.static('public'))

app.get('/healthz', function (req, res) {
  res.sendStatus(200);
})

app.post('/order', function (req, res) {
  const payload = JSON.stringify(req.body);
  const topic = pubsub.topic(topicName);
  topic.publish(Buffer.from(payload))
  .then(() => {
    console.log(`order sent to the kitchen 👩🏼‍🍳👨🏻‍🍳`);
    res.sendStatus(201);
  })
  .catch(error => {
    console.error(error);
    res.sendStatus(500);
  });
})


console.log('ready to take your order 📝');
app.listen(3000)