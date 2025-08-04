import React, { useState } from "react";

const Cart = ({ items }) => {
    const [cartItems, setCartItems] = useState(items);
    const [subTotal, setSubTotal] = useState(() => parseFloat(cartItems.reduce((total, item) => total + item.total, 0)));
    const [customerName, setCustomerName] = useState('');
    const [email, setEmail] = useState('');
    const [phone, setPhone] = useState('');
    const [shippingAddress, setShippingAddress] = useState('');
    const [billingAddress, setBillingAddress] = useState('');
    const [sameAsBilling, setSameAsBilling] = useState(true);
    const [paymentMethod, setPaymentMethod] = useState('bank_transfer');
    const [shippingOption, setShippingOption] = useState('standard');
    const [notes, setNotes] = useState('');
    const [agreeTerms, setAgreeTerms] = useState(false);
    const [isSubmitting, setIsSubmitting] = useState(false);
    const getShippingCost = () => {
        switch (shippingOption) {
            case 'express':
                return 5.00;
            case 'standard':
            case 'pickup':
            default:
                return 0.00;
        }
    };

    const getTaxAmount = () => {
        // Ecuador IVA is typically 12%
        const taxRate = 0.12;
        return subTotal * taxRate;
    };

    const getTotalAmount = () => {
        return subTotal + getShippingCost() + getTaxAmount();
    };
    const updateQuantity = async (id, delta) => {
        const updatedItems = cartItems.map(item =>
            item.product.id === id
                ? { ...item, quantity: Math.max(1, item.quantity + delta) }
                : item
        );
        setCartItems(updatedItems);
        setSubTotal(updatedItems.reduce((total, item) => total + (item.quantity * item.product.selling_price), 0));

        const updatedItem = updatedItems.find(item => item.product.id === id);

        // Update Rails session
        await fetch("/cart/update_item", {
            method: "PATCH",
            headers: { "Content-Type": "application/json", "X-CSRF-Token": getCsrfToken() },
            body: JSON.stringify({
                product_id: id,
                quantity: updatedItem.quantity,
            }),
        });
    };

    const removeItem = async (id) => {
        setCartItems(cartItems.filter(item => item.product.id !== id));

        // Update Rails session
        await fetch("/cart/remove_item", {
            method: "DELETE",
            headers: { "Content-Type": "application/json", "X-CSRF-Token": getCsrfToken() },
            body: JSON.stringify({ product_id: id }),
        });
    };

    const clearCart = async () => {
        await fetch("/cart/clear", {
            method: "DELETE",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": getCsrfToken(),
            },
        });
        setCartItems([]);
    };

    const handleSubmit = async (e) => {
        e.preventDefault();

        // Additional validation check
        if (!isFormValid()) {
            alert('Please fill in all required fields and accept the terms and conditions.');
            return;
        }

        setIsSubmitting(true);

        try {
            const orderData = {
                customer_name: customerName,
                customer_email: email,
                customer_phone: phone,
                shipping_address: shippingAddress,
                billing_address: sameAsBilling ? shippingAddress : billingAddress,
                payment_method: paymentMethod,
                notes: notes,
                subtotal: subTotal,
                tax_amount: getTaxAmount(),
                shipping_cost: getShippingCost(),
                total_amount: getTotalAmount(),
                shipping_option: shippingOption
            };

            const response = await fetch('/cart/checkout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': getCsrfToken(),
                },
                body: JSON.stringify(orderData)
            });

            if (response.ok) {
                const result = await response.json();
                if (result.redirect_url) {
                    window.location.href = result.redirect_url;
                } else {
                    clearCart();
                    alert('Order placed successfully!');
                }
            } else {
                throw new Error('Failed to place order');
            }
        } catch (error) {
            console.error('Error placing order:', error);
            alert('There was an error placing your order. Please try again.');
        } finally {
            setIsSubmitting(false);
        }
    };

    // WhatsApp order handler
    const handleWhatsAppOrder = () => {

        if (!isFormValid()) {
            alert('Please fill in all required fields and accept the terms and conditions.');
            return;
        }

        const orderSummary = `
*New Order - Percussion Ecuador*

*Customer:* ${customerName}
*Email:* ${email}
*Phone:* ${phone}

*Shipping Address:*
${shippingAddress}

*Items:*
${cartItems.map(item => `• ${item.product.name} x${item.quantity} - $${item.total.toFixed(2)}`).join('\n')}

*Order Summary:*
Subtotal: $${subtotal.toFixed(2)}
Shipping: ${getShippingCost() === 0 ? 'Free' : `$${getShippingCost().toFixed(2)}`}
Tax: $${getTaxAmount().toFixed(2)}
*Total: $${getTotalAmount().toFixed(2)}*

*Payment Method:* ${paymentMethod.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase())}

${notes ? `*Notes:* ${notes}` : ''}
    `.trim();

        const whatsappUrl = `https://wa.me/593996888655?text=${encodeURIComponent(orderSummary)}`;
        window.open(whatsappUrl, '_blank');
    };

    // Form validation
    const isFormValid = () => {
        return (
            customerName.trim() !== '' &&
            email.trim() !== '' &&
            phone.trim() !== '' &&
            shippingAddress.trim() !== '' &&
            (!sameAsBilling ? billingAddress.trim() !== '' : true) &&
            paymentMethod !== '' &&
            agreeTerms
        );
    };

    const getCsrfToken = () => {
        return document.querySelector("meta[name='csrf-token']").content;
    };
    console.log("Rendering Cart component with items:", cartItems);
    return (
        cartItems.length !== 0 ? (
            <div className="row">
                <div className="col-lg-8">
                    <div className="card border-0 shadow-sm mb-4">
                        <div className="card-header bg-white border-bottom">
                            <h4 className="mb-0 fw-semibold">Cart Items ({items.length})</h4>
                        </div>
                        <div className="card-body p-0">
                            {cartItems.map(item => (
                                <div className="cart-item p-4" key={item.product.id}>
                                    <div className="row align-items-center">
                                        <div className="col-md-2">
                                            <div className="product-image d-flex align-items-center justify-content-center" style={{ height: "80px", backgroundColor: "#f8f9fa", borderRadius: "8px" }}>
                                                {item.image_url ? (
                                                    <img
                                                        src={item.image_url}
                                                        alt={item.product.name}
                                                        className="img-fluid rounded"
                                                    />
                                                ) : (
                                                    <i className="fas fa-drum text-primary" style={{ fontSize: "2rem", opacity: 0.3 }}></i>
                                                )}
                                            </div>
                                        </div>
                                        <div className="col-md-4">
                                            <h5 className="fw-semibold mb-1">{item.product.name}</h5>
                                            <p className="text-muted mb-1 small">{item.product.description.slice(0, 60)} ...</p>
                                            <div className="text-primary fw-bold">${item.product.selling_price}</div>
                                        </div>
                                        <div className="col-md-3">
                                            <div className="quantity-selector mb-4">
                                                <label htmlFor="quantity_${item.product.id}" className="form-label fw-semibold">Quantity:</label>
                                                <div className="input-group" style={{ maxWidth: 150 + 'px' }}>
                                                    <button className="btn btn-outline-secondary" onClick={() => updateQuantity(item.product.id, -1)}><i className="fas fa-minus"></i></button>
                                                    <input id="quantity_${item.product.id}" type="number" className="form-control text-center" onChange={
                                                        (e) => {
                                                            const newValue = parseInt(e.target.value, 10);
                                                            if (!isNaN(newValue) && newValue > 0) {
                                                                updateQuantity(item.product.id, newValue - item.quantity);
                                                            }
                                                        }
                                                    } min="1" max={item.product.stock} value={item.quantity
                                                    } ></input>
                                                    <button className="btn btn-outline-secondary" onClick={() => updateQuantity(item.product.id, 1)}><i className="fas fa-plus"></i></button>
                                                </div>
                                            </div>
                                        </div>
                                        <div className="col-md-2 text-end">
                                            <div className="h5 text-primary fw-bold mb-2">$ {(item.quantity * item.product.selling_price).toFixed(2)}</div>
                                            <button className="btn btn-outline-danger btn-sm" onClick={() => removeItem(item.product.id)}>
                                                <i className="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>
                        {/* Continue Shopping and Clear Cart */}
                        <div className="d-flex justify-content-between align-items-center mt-3">
                            <a href="/products" className="btn btn-outline-primary">
                                <i className="fas fa-arrow-left me-2"></i>Continue Shopping
                            </a>
                            <button type="button" className="btn btn-outline-secondary" onClick={clearCart}>
                                <i className="fas fa-trash me-2"></i>Clear Cart
                            </button>
                        </div>
                    </div>
                    {/* <!-- Order Summary --> */}
                    <div className="col-lg-4 mt-4">
                        <div className="card border-0 shadow-sm sticky-top" style={{ top: "100px" }}>
                            <div className="card-header bg-primary text-white">
                                <h4 className="mb-0 fw-semibold">Order Summary</h4>
                            </div>
                            <div className="card-body">
                                <div className="d-flex justify-content-between mb-3">
                                    <span>Subtotal:</span>
                                    <span className="fw-semibold">${subTotal.toFixed(2)}</span>
                                </div>
                                <div className="d-flex justify-content-between mb-3">
                                    <span>Tax:</span>
                                    <span>${getTaxAmount().toFixed(2)}</span>
                                </div>
                                <hr />
                                <div className="d-flex justify-content-between mb-4">
                                    <span className="h5 fw-bold">Total:</span>
                                    <span className="h5 fw-bold text-primary">${getTotalAmount().toFixed(2)}</span>
                                </div>
                                {/* Enhanced Checkout Form */}
                                <form className="checkout-form" onSubmit={handleSubmit}>
                                    {/* Customer Information */}
                                    <div className="checkout-section mb-4">
                                        <h5 className="fw-semibold mb-3 text-primary">
                                            <i className="fas fa-user me-2"></i>Customer Information
                                        </h5>

                                        <div className="row">
                                            <div className="col-md-6 mb-3">
                                                <label htmlFor="customerName" className="form-label fw-semibold">
                                                    Full Name *
                                                </label>
                                                <input
                                                    type="text"
                                                    id="customerName"
                                                    className="form-control"
                                                    placeholder="Your full name"
                                                    value={customerName}
                                                    onChange={(e) => setCustomerName(e.target.value)}
                                                    required
                                                />
                                            </div>

                                            <div className="col-md-6 mb-3">
                                                <label htmlFor="email" className="form-label fw-semibold">
                                                    Email Address *
                                                </label>
                                                <input
                                                    type="email"
                                                    id="email"
                                                    className="form-control"
                                                    placeholder="your@email.com"
                                                    value={email}
                                                    onChange={(e) => setEmail(e.target.value)}
                                                    required
                                                />
                                                <div className="form-text">Order confirmation will be sent here</div>
                                            </div>
                                        </div>

                                        <div className="mb-3">
                                            <label htmlFor="phone" className="form-label fw-semibold">
                                                Phone Number *
                                            </label>
                                            <input
                                                type="tel"
                                                id="phone"
                                                className="form-control"
                                                placeholder="+593 999 999 999"
                                                value={phone}
                                                onChange={(e) => setPhone(e.target.value)}
                                                required
                                            />
                                            <div className="form-text">Required for delivery coordination</div>
                                        </div>
                                    </div>

                                    {/* Shipping Information */}
                                    <div className="checkout-section mb-4">
                                        <h5 className="fw-semibold mb-3 text-primary">
                                            <i className="fas fa-shipping-fast me-2"></i>Shipping Information
                                        </h5>

                                        <div className="mb-3">
                                            <label htmlFor="shippingAddress" className="form-label fw-semibold">
                                                Shipping Address *
                                            </label>
                                            <textarea
                                                id="shippingAddress"
                                                className="form-control"
                                                rows="3"
                                                placeholder="Street address, city, province, postal code"
                                                value={shippingAddress}
                                                onChange={(e) => setShippingAddress(e.target.value)}
                                                required
                                            />
                                        </div>

                                        <div className="form-check mb-3">
                                            <input
                                                className="form-check-input"
                                                type="checkbox"
                                                id="sameAsBilling"
                                                checked={sameAsBilling}
                                                onChange={(e) => setSameAsBilling(e.target.checked)}
                                            />
                                            <label className="form-check-label" htmlFor="sameAsBilling">
                                                Billing address is the same as shipping address
                                            </label>
                                        </div>

                                        {!sameAsBilling && (
                                            <div className="mb-3">
                                                <label htmlFor="billingAddress" className="form-label fw-semibold">
                                                    Billing Address *
                                                </label>
                                                <textarea
                                                    id="billingAddress"
                                                    className="form-control"
                                                    rows="3"
                                                    placeholder="Street address, city, province, postal code"
                                                    value={billingAddress}
                                                    onChange={(e) => setBillingAddress(e.target.value)}
                                                    required={!sameAsBilling}
                                                />
                                            </div>
                                        )}
                                    </div>

                                    {/* Payment Method */}
                                    <div className="checkout-section mb-4">
                                        <h5 className="fw-semibold mb-3 text-primary">
                                            <i className="fas fa-credit-card me-2"></i>Payment Method
                                        </h5>

                                        <div className="payment-methods">
                                            <div className="form-check mb-2">
                                                <input
                                                    className="form-check-input"
                                                    type="radio"
                                                    name="paymentMethod"
                                                    id="bank_transfer"
                                                    value="bank_transfer"
                                                    checked={paymentMethod === 'bank_transfer'}
                                                    onChange={(e) => setPaymentMethod(e.target.value)}
                                                />
                                                <label className="form-check-label d-flex align-items-center" htmlFor="bank_transfer">
                                                    <i className="fas fa-university me-2 text-primary"></i>
                                                    Bank Transfer
                                                </label>
                                            </div>

                                            <div className="form-check mb-2">
                                                <input
                                                    className="form-check-input"
                                                    type="radio"
                                                    name="paymentMethod"
                                                    id="cash_on_delivery"
                                                    value="cash_on_delivery"
                                                    checked={paymentMethod === 'cash_on_delivery'}
                                                    onChange={(e) => setPaymentMethod(e.target.value)}
                                                />
                                                <label className="form-check-label d-flex align-items-center" htmlFor="cash_on_delivery">
                                                    <i className="fas fa-money-bill-wave me-2 text-success"></i>
                                                    Cash on Delivery
                                                </label>
                                            </div>

                                            <div className="form-check mb-2">
                                                <input
                                                    className="form-check-input"
                                                    type="radio"
                                                    name="paymentMethod"
                                                    id="whatsapp_order"
                                                    value="whatsapp_order"
                                                    checked={paymentMethod === 'whatsapp_order'}
                                                    onChange={(e) => setPaymentMethod(e.target.value)}
                                                />
                                                <label className="form-check-label d-flex align-items-center" htmlFor="whatsapp_order">
                                                    <i className="fab fa-whatsapp me-2 text-success"></i>
                                                    WhatsApp Order (Payment arranged separately)
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    {/* Shipping Options */}
                                    <div className="checkout-section mb-4">
                                        <h5 className="fw-semibold mb-3 text-primary">
                                            <i className="fas fa-truck me-2"></i>Shipping Options
                                        </h5>

                                        <div className="shipping-options">
                                            <div className="form-check mb-2">
                                                <input
                                                    className="form-check-input"
                                                    type="radio"
                                                    name="shippingOption"
                                                    id="standard_shipping"
                                                    value="standard"
                                                    checked={shippingOption === 'standard'}
                                                    onChange={(e) => setShippingOption(e.target.value)}
                                                />
                                                <label className="form-check-label d-flex justify-content-between" htmlFor="standard_shipping">
                                                    <span>Standard Shipping (3-5 business days)</span>
                                                    <span className="text-success fw-semibold">Free</span>
                                                </label>
                                            </div>

                                            <div className="form-check mb-2">
                                                <input
                                                    className="form-check-input"
                                                    type="radio"
                                                    name="shippingOption"
                                                    id="express_shipping"
                                                    value="express"
                                                    checked={shippingOption === 'express'}
                                                    onChange={(e) => setShippingOption(e.target.value)}
                                                />
                                                <label className="form-check-label d-flex justify-content-between" htmlFor="express_shipping">
                                                    <span>Express Shipping (1-2 business days)</span>
                                                    <span className="fw-semibold">$5.00</span>
                                                </label>
                                            </div>

                                            <div className="form-check mb-2">
                                                <input
                                                    className="form-check-input"
                                                    type="radio"
                                                    name="shippingOption"
                                                    id="pickup"
                                                    value="pickup"
                                                    checked={shippingOption === 'pickup'}
                                                    onChange={(e) => setShippingOption(e.target.value)}
                                                />
                                                <label className="form-check-label d-flex justify-content-between" htmlFor="pickup">
                                                    <span>Store Pickup (Available next day)</span>
                                                    <span className="text-success fw-semibold">Free</span>
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    {/* Order Notes */}
                                    <div className="checkout-section mb-4">
                                        <h5 className="fw-semibold mb-3 text-primary">
                                            <i className="fas fa-sticky-note me-2"></i>Additional Information
                                        </h5>

                                        <div className="mb-3">
                                            <label htmlFor="notes" className="form-label fw-semibold">
                                                Order Notes (Optional)
                                            </label>
                                            <textarea
                                                id="notes"
                                                className="form-control"
                                                rows="3"
                                                placeholder="Any special instructions, delivery preferences, or questions..."
                                                value={notes}
                                                onChange={(e) => setNotes(e.target.value)}
                                            />
                                        </div>
                                    </div>

                                    {/* Terms and Conditions */}
                                    <div className="checkout-section mb-4">
                                        <div className="form-check">
                                            <input
                                                className="form-check-input"
                                                type="checkbox"
                                                id="agreeTerms"
                                                checked={agreeTerms}
                                                onChange={(e) => setAgreeTerms(e.target.checked)}
                                                required
                                            />
                                            <label className="form-check-label" htmlFor="agreeTerms">
                                                I agree to the <a href="#" className="text-primary">Terms and Conditions</a> and
                                                <a href="#" className="text-primary"> Privacy Policy</a> *
                                            </label>
                                        </div>
                                    </div>

                                    {/* Order Summary Display */}
                                    <div className="order-summary-checkout mb-4 p-3 bg-light rounded">
                                        <div className="d-flex justify-content-between mb-2">
                                            <span>Subtotal:</span>
                                            <span>${subTotal.toFixed(2)}</span>
                                        </div>
                                        <div className="d-flex justify-content-between mb-2">
                                            <span>Shipping:</span>
                                            <span>{getShippingCost() === 0 ? 'Free' : `$${getShippingCost().toFixed(2)}`}</span>
                                        </div>
                                        <div className="d-flex justify-content-between mb-2">
                                            <span>Tax:</span>
                                            <span>${getTaxAmount().toFixed(2)}</span>
                                        </div>
                                        <hr />
                                        <div className="d-flex justify-content-between">
                                            <span className="fw-bold">Total:</span>
                                            <span className="fw-bold text-primary">${getTotalAmount().toFixed(2)}</span>
                                        </div>
                                    </div>

                                    {/* Submit Buttons */}
                                    <div className="d-grid gap-2">
                                        <button
                                            type="submit"
                                            className="btn btn-primary btn-lg"
                                            disabled={isSubmitting || !isFormValid()}
                                        >
                                            {isSubmitting ? (
                                                <>
                                                    <i className="fas fa-spinner fa-spin me-2"></i>
                                                    Processing Order...
                                                </>
                                            ) : (
                                                <>
                                                    <i className="fas fa-check me-2"></i>
                                                    Place Order
                                                </>
                                            )}
                                        </button>

                                        {paymentMethod === 'whatsapp_order' && (
                                            <button
                                                type="button"
                                                className="btn btn-success"
                                                disabled={!isFormValid()}
                                                onClick={handleWhatsAppOrder}
                                            >
                                                <i className="fab fa-whatsapp me-2"></i>
                                                Continue with WhatsApp
                                            </button>
                                        )}
                                    </div>

                                    {/* Validation Status Display */}
                                    {!isFormValid() && (
                                        <div className="alert alert-warning mt-3">
                                            <i className="fas fa-exclamation-triangle me-2"></i>
                                            Please fill in all required fields and accept the terms and conditions.
                                        </div>
                                    )}
                                </form>

                                {/* <!-- Alternative Contact Methods --> */}
                                <div className="text-center">
                                    <p className="text-muted mb-3">Or contact us directly:</p>
                                    <div className="d-grid gap-2">
                                        <a href="https://wa.me/593996888655" className="btn btn-success">
                                            <i className="fab fa-whatsapp me-2"></i>Order via WhatsApp
                                        </a>
                                        <a href="mailto:info@percusionecuador.com" className="btn btn-outline-primary">
                                            <i className="fas fa-envelope me-2"></i>Email Us
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        ) : (
            // <!-- Empty Cart -->
            <div className="row justify-content-center">
                <div className="col-lg-6 text-center">
                    <div className="empty-cart py-5">
                        <div className="mb-4">
                            <i className="fas fa-shopping-cart text-muted" style={{ fontSize: "5rem", opacity: 0.3 }}></i>
                        </div>
                        <h3 className="fw-semibold mb-3">Your cart is empty</h3>
                        <p className="text-muted fs-5 mb-4">Start adding some percussion instruments to your cart!</p>
                        <a href="/products" className="btn btn-primary btn-lg">
                            <i className="fas fa-drum me-2"></i>Browse Products
                        </a>
                    </div>
                </div>
            </div>
        )
    );
};

export default Cart;

