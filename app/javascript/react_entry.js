import React from "react";
import ReactDOM from "react-dom/client";
import Cart from "./components/Cart";

// Mount React components dynamically
document.addEventListener("DOMContentLoaded", () => {
  const cartElement = document.getElementById("cart");
  if (cartElement) {
    const items = JSON.parse(cartElement.dataset.items || "[]");
    const root = ReactDOM.createRoot(cartElement);
    root.render(<Cart items={items} />);
  }
});
