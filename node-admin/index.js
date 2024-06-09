const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const dotenv = require('dotenv')

dotenv.config()

const app = express();
const port = process.env.PORT || 3000;

mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/admin');
const db = mongoose.connection;
db.on('error', (error) => console.error(error));
db.once('open', function () {
    console.log('Connected to MongoDB');
});

app.use(bodyParser.json());

app.get('/', (req, res) => {
    res.json({ message: 'Hello World!' });
})

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

const { Schema, model } = mongoose;
const userSchema = new Schema({
    name: String,
    age: Number,
    email: String
});
const User = model('User', userSchema);