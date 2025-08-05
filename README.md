# Inventory Management System

A comprehensive Ruby on Rails web application designed for managing products, inventory, and sales operations. This system provides both public-facing e-commerce functionality and an administrative interface for business management.

## Overview

This inventory management system serves as a complete solution for businesses looking to manage their product catalog, track inventory levels, process orders, and maintain vendor relationships. The application features a dual interface approach with a customer-facing storefront and a powerful administrative backend.

## Key Features

### Public Storefront
- **Product Catalog**: Browse and search through available products with detailed information
- **Category Navigation**: Organized product browsing by categories
- **Shopping Cart**: Add products to cart, modify quantities, and manage selections
- **Product Search**: Advanced search functionality across product names, descriptions, and vendor information
- **Sorting & Filtering**: Multiple sorting options including price, name, date, and stock levels
- **Responsive Design**: Mobile-friendly interface for seamless shopping experience

### Administrative Interface (ActiveAdmin)
- **Product Management**: Complete CRUD operations for products with image support
- **Category Management**: Organize and maintain product categories
- **Vendor Management**: Track and manage supplier information
- **Inventory Tracking**: Monitor stock quantities and set minimum stock levels
- **Order Management**: Process and track customer orders
- **Stock Movement Tracking**: Detailed logging of inventory changes
- **User Management**: Administrative user account management

### Inventory Features
- **Stock Quantity Monitoring**: Real-time tracking of product availability
- **Low Stock Alerts**: Automatic identification of products below minimum levels
- **Stock Movement History**: Comprehensive audit trail of inventory changes
- **Minimum Stock Level Settings**: Configurable thresholds for reorder alerts

### Product Management
- **Detailed Product Information**: Name, description, SKU, pricing, and stock data
- **Category Organization**: Hierarchical product categorization
- **Vendor Tracking**: Associate products with suppliers
- **Image Management**: Product photo uploads and management
- **Pricing Control**: Separate cost and selling price tracking

## Technical Architecture

### Core Models
- **Product**: Central entity containing product information, pricing, and stock data
- **Category**: Product categorization with validation for uniqueness
- **Vendor**: Supplier information and product associations
- **Order**: Customer order processing and tracking
- **OrderItem**: Individual items within orders
- **StockMovement**: Inventory change tracking and audit trail
- **User**: Customer account management
- **AdminUser**: Administrative access control

### Key Relationships
- Products belong to categories and vendors
- Orders contain multiple order items
- Stock movements track product quantity changes
- Categories can have multiple products
- Vendors can supply multiple products

### Search and Filtering
- **Ransack Integration**: Advanced search capabilities across models
- **Multi-field Search**: Search across product names, descriptions, and vendor information
- **Dynamic Filtering**: Real-time filtering by categories, price ranges, and availability
- **Sorting Options**: Multiple sorting criteria including price, name, date, and stock levels

### Pagination and Performance
- **Kaminari Integration**: Efficient pagination across all list views
- **Optimized Queries**: Includes statements to prevent N+1 query problems
- **Configurable Page Sizes**: Flexible pagination options for different views

## User Roles and Permissions

### Public Users
- Browse product catalog
- Use shopping cart functionality
- Search and filter products
- View product details and vendor information

### Administrative Users
- Full CRUD access to all models
- Inventory management capabilities
- Order processing and tracking
- User management functions
- Stock movement monitoring

## Security Features
- **Devise Authentication**: Secure user authentication system
- **Parameter Filtering**: Strong parameters to prevent mass assignment
- **Admin User Separation**: Distinct authentication for administrative access
- **Input Validation**: Comprehensive model-level validations

## Business Intelligence
- **Stock Analytics**: High and low quantity product identification
- **Product Metrics**: Latest products and inventory statistics
- **Order Tracking**: Comprehensive order management system
- **Vendor Relations**: Supplier performance and product association tracking

This inventory management system provides a robust foundation for businesses requiring comprehensive product and inventory management with both customer-facing and administrative capabilities.