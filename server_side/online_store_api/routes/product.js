const express = require('express');
const router = express.Router();
const Product = require('../model/product');
const multer = require('multer');
const { uploadProduct } = require('../uploadFile');
const asyncHandler = require('express-async-handler');
require('dotenv').config();

const BASE_URL = process.env.BASE_URL || 'http://localhost:3000';

// Get all products
router.get('/', asyncHandler(async (req, res) => {
    try {
        const products = await Product.find()
            .populate('proCategoryId', 'id name')
            .populate('proSubCategoryId', 'id name')
            .populate('proBrandId', 'id name')
            .populate('proVariantTypeId', 'id type')
            .populate('proVariantId', 'id name');
        res.json({ success: true, message: "Products retrieved successfully.", data: products });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
}));

// Get a product by ID
router.get('/:id', asyncHandler(async (req, res) => {
    try {
        const productID = req.params.id;
        const product = await Product.findById(productID)
            .populate('proCategoryId', 'id name')
            .populate('proSubCategoryId', 'id name')
            .populate('proBrandId', 'id name')
            .populate('proVariantTypeId', 'id name')
            .populate('proVariantId', 'id name');

        if (!product) {
            return res.status(404).json({ success: false, message: "Product not found." });
        }
        res.json({ success: true, message: "Product retrieved successfully.", data: product });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
}));

// Create new product
router.post('/', asyncHandler(async (req, res) => {
    try {
        uploadProduct.fields([
            { name: 'image1', maxCount: 1 },
            { name: 'image2', maxCount: 1 },
            { name: 'image3', maxCount: 1 },
            { name: 'image4', maxCount: 1 },
            { name: 'image5', maxCount: 1 }
        ])(req, res, async function (err) {
            if (err instanceof multer.MulterError || err) {
                return res.status(400).json({ success: false, message: err.message });
            }

            const {
                name, description, quantity, price, offerPrice,
                proCategoryId, proSubCategoryId, proBrandId,
                proVariantTypeId, proVariantId
            } = req.body;

            if (!name || !quantity || !price || !proCategoryId || !proSubCategoryId) {
                return res.status(400).json({ success: false, message: "Required fields are missing." });
            }

            const imageUrls = [];
            const fields = ['image1', 'image2', 'image3', 'image4', 'image5'];
            fields.forEach((field, index) => {
                if (req.files[field]?.length > 0) {
                    const file = req.files[field][0];
                    const imageUrl = `${BASE_URL}/image/products/${file.filename}`;
                    imageUrls.push({ image: index + 1, url: imageUrl });
                }
            });

            const newProduct = new Product({
                name, description, quantity, price, offerPrice,
                proCategoryId, proSubCategoryId, proBrandId,
                proVariantTypeId, proVariantId,
                images: imageUrls
            });

            await newProduct.save();
            res.json({ success: true, message: "Product created successfully.", data: null });
        });
    } catch (error) {
        console.error("Error creating product:", error);
        res.status(500).json({ success: false, message: error.message });
    }
}));

// Update a product
router.put('/:id', asyncHandler(async (req, res) => {
    const productId = req.params.id;

    try {
        uploadProduct.fields([
            { name: 'image1', maxCount: 1 },
            { name: 'image2', maxCount: 1 },
            { name: 'image3', maxCount: 1 },
            { name: 'image4', maxCount: 1 },
            { name: 'image5', maxCount: 1 }
        ])(req, res, async function (err) {
            if (err) {
                return res.status(400).json({ success: false, message: err.message });
            }

            const {
                name, description, quantity, price, offerPrice,
                proCategoryId, proSubCategoryId, proBrandId,
                proVariantTypeId, proVariantId
            } = req.body;

            const product = await Product.findById(productId);
            if (!product) {
                return res.status(404).json({ success: false, message: "Product not found." });
            }

            product.name = name || product.name;
            product.description = description || product.description;
            product.quantity = quantity || product.quantity;
            product.price = price || product.price;
            product.offerPrice = offerPrice || product.offerPrice;
            product.proCategoryId = proCategoryId || product.proCategoryId;
            product.proSubCategoryId = proSubCategoryId || product.proSubCategoryId;
            product.proBrandId = proBrandId || product.proBrandId;
            product.proVariantTypeId = proVariantTypeId || product.proVariantTypeId;
            product.proVariantId = proVariantId || product.proVariantId;

            const fields = ['image1', 'image2', 'image3', 'image4', 'image5'];
            fields.forEach((field, index) => {
                if (req.files[field]?.length > 0) {
                    const file = req.files[field][0];
                    const imageUrl = `${BASE_URL}/image/products/${file.filename}`;
                    const existingImage = product.images.find(img => img.image === index + 1);
                    if (existingImage) {
                        existingImage.url = imageUrl;
                    } else {
                        product.images.push({ image: index + 1, url: imageUrl });
                    }
                }
            });

            await product.save();
            res.json({ success: true, message: "Product updated successfully." });
        });
    } catch (error) {
        console.error("Error updating product:", error);
        res.status(500).json({ success: false, message: error.message });
    }
}));

// Delete a product
router.delete('/:id', asyncHandler(async (req, res) => {
    try {
        const product = await Product.findByIdAndDelete(req.params.id);
        if (!product) {
            return res.status(404).json({ success: false, message: "Product not found." });
        }
        res.json({ success: true, message: "Product deleted successfully." });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
}));

module.exports = router;
