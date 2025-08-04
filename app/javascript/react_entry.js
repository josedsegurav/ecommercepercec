import React from "react";
import ReactDOM from "react-dom/client";
import Cart from "./components/Cart";

// Mount React components dynamically
document.addEventListener("DOMContentLoaded", () => {
  const cartElement = document.getElementById("cart");
  if (cartElement) {
    console.log("Raw data-items:", cartElement.dataset.items);
    const items = JSON.parse(cartElement.dataset.items || "[]");
    console.log("Parsed items:", items);
    const root = ReactDOM.createRoot(cartElement);
    root.render(<Cart items={items} />);
  }
});
