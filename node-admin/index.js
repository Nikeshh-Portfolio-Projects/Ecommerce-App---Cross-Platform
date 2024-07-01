const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mongoose = require('mongoose');
const asyncHandler = require('express-async-handler');
const dotenv = require('dotenv')

dotenv.config()

const app = express();
// Middleware
app.use(cors({ origin: '*' }));
app.use(bodyParser.json());
// Setting static folder path
app.use('/image/products', express.static(path.join(__dirname, 'public/images/products')));
app.use('/image/category', express.static(path.join(__dirname, 'public/images/category')));
app.use('/image/poster', express.static(path.join(__dirname, 'public/images/posters')));

const URL = process.env.MONGODB_URI || 'mongodb://localhost:27017/admin';
mongoose.connect(URL);

const db = mongoose.connection;
db.on('error', (error) => console.error(error));
db.once('open', function () {
    console.log('Connected to MongoDB');
});

// Routes
app.use('/categories', require('./routes/category'));
app.use('/subCategories', require('./routes/subCategory'));
app.use('/brands', require('./routes/brand'));
app.use('/variantTypes', require('./routes/variantType'));
app.use('/variants', require('./routes/variant'));
app.use('/products', require('./routes/product'));
app.use('/couponCodes', require('./routes/couponCode'));
app.use('/posters', require('./routes/poster'));
app.use('/users', require('./routes/user'));
app.use('/orders', require('./routes/order'));
app.use('/payment', require('./routes/payment'));
app.use('/notification', require('./routes/notification'));

// Health check
app.get('/', asyncHandler(async (req, res) => {
    res.json({ error: false, message: 'API working successfully', data: null });
}));

// Global error handler
app.use((err, req, res, next) => {
    res.status(500).json({ error: true, message: err.message, data: null });
});

app.listen(process.env.PORT || 3000, () => {
    console.log(`Server is running on port ${process.env.PORT || 3000}`);
});