"use client";

import { useCart } from "@/context/CartContext";
import Image from "next/image";
import { useState } from "react";

export default function CartDrawer() {
    const { cart, isCartOpen, toggleCart, removeFromCart, updateQuantity, cartTotal, clearCart } = useCart();
    const [isCheckingOut, setIsCheckingOut] = useState(false);

    const handleCheckout = async () => {
        try {
            setIsCheckingOut(true);

            // Format for Formspree
            const formspreeData = {
                subject: "New Order from ClickCart",
                order_details: cart.map(item => `${item.name} (${item.quantity}x) - $${(item.price * item.quantity).toFixed(2)}`).join("\n"),
                total: `$${cartTotal.toFixed(2)}`
            };

            const formspreeEndpoint = process.env.NEXT_PUBLIC_FORMSPREE_URL || "https://formspree.io/f/placeholder";

            if (formspreeEndpoint !== "https://formspree.io/f/placeholder") {
                await fetch(formspreeEndpoint, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "Accept": "application/json"
                    },
                    body: JSON.stringify(formspreeData)
                });
            } else {
                console.log("Formspree URL not configured. Skipping formspree submission.", formspreeData);
            }

            // Continue to Stripe after logging to Formspree database
            const res = await fetch("/api/checkout", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ items: cart }),
            });
            const data = await res.json();

            if (data.url) {
                clearCart();
                window.location.href = data.url;
            } else {
                alert("Failed to initiate checkout (missing Stripe URL)");
                setIsCheckingOut(false);
            }
        } catch (e) {
            console.error("Checkout failed", e);
            alert("Failed to initiate checkout. Check console for details.");
            setIsCheckingOut(false);
        }
    };

    return (
        <>
            {/* Backdrop */}
            {isCartOpen && (
                <div
                    className="fixed inset-0 bg-black/50 z-[60] backdrop-blur-sm transition-opacity"
                    onClick={toggleCart}
                />
            )}

            {/* Drawer */}
            <div
                className={`fixed top-0 right-0 h-full w-full sm:w-[450px] bg-background shadow-2xl z-[70] transform transition-transform duration-300 ease-in-out flex flex-col ${isCartOpen ? "translate-x-0" : "translate-x-full"
                    }`}
            >
                <div className="p-4 sm:p-6 border-b border-border flex items-center justify-between bg-card text-card-foreground">
                    <h2 className="text-2xl font-extrabold text-primary">Your Cart</h2>
                    <button
                        onClick={toggleCart}
                        className="w-10 h-10 flex items-center justify-center rounded-full bg-secondary text-secondary-foreground hover:bg-border hover:rotate-90 transition-all text-2xl font-medium"
                    >
                        ×
                    </button>
                </div>

                <div className="flex-1 overflow-y-auto p-4 sm:p-6 flex flex-col gap-5">
                    {cart.length === 0 ? (
                        <div className="flex flex-col items-center justify-center h-full text-center opacity-70">
                            <span className="text-7xl mb-6 grayscale opacity-60">🛍️</span>
                            <p className="text-xl font-medium mb-4">Your cart is feeling a bit empty.</p>
                            <button
                                onClick={toggleCart}
                                className="bg-primary text-primary-foreground px-8 py-3 rounded-full font-bold hover:scale-105 transition-transform"
                            >
                                Browse Our Offerings
                            </button>
                        </div>
                    ) : (
                        cart.map((item) => (
                            <div key={item.id} className="flex gap-4 bg-card rounded-2xl p-3 border border-border shadow-sm group">
                                <div className="relative w-24 h-24 rounded-xl overflow-hidden bg-secondary shrink-0">
                                    <Image src={item.image} alt={item.name} fill className="object-cover group-hover:scale-110 transition-transform duration-500" />
                                </div>
                                <div className="flex flex-col flex-1 py-1">
                                    <h3 className="font-extrabold text-foreground mb-1 leading-tight">{item.name}</h3>
                                    <p className="text-primary font-bold text-lg">${item.price.toFixed(2)}</p>

                                    <div className="flex items-center justify-between mt-auto pt-2">
                                        <div className="flex items-center gap-1 bg-secondary rounded-full p-1 border border-border">
                                            <button
                                                onClick={() => updateQuantity(item.id, item.quantity - 1)}
                                                className="w-7 h-7 flex items-center justify-center rounded-full bg-background hover:text-primary font-bold shadow-sm"
                                                disabled={item.quantity <= 1}
                                            >
                                                -
                                            </button>
                                            <span className="font-bold w-6 text-center text-secondary-foreground">{item.quantity}</span>
                                            <button
                                                onClick={() => updateQuantity(item.id, item.quantity + 1)}
                                                className="w-7 h-7 flex items-center justify-center rounded-full bg-background hover:text-primary font-bold shadow-sm"
                                            >
                                                +
                                            </button>
                                        </div>
                                        <button
                                            onClick={() => removeFromCart(item.id)}
                                            className="text-sm text-red-500 hover:text-red-600 font-bold px-2 py-1 rounded-md hover:bg-red-50 transition-colors"
                                        >
                                            Remove
                                        </button>
                                    </div>
                                </div>
                            </div>
                        ))
                    )}
                </div>

                {cart.length > 0 && (
                    <div className="border-t border-border p-4 sm:p-6 bg-card">
                        <div className="flex justify-between items-center mb-6">
                            <span className="text-xl font-bold text-foreground">Subtotal</span>
                            <span className="text-3xl font-extrabold text-primary">${cartTotal.toFixed(2)}</span>
                        </div>
                        <button
                            onClick={handleCheckout}
                            disabled={isCheckingOut}
                            className="w-full bg-primary text-primary-foreground py-4 rounded-full font-extrabold text-xl shadow-xl hover:shadow-primary/40 hover:-translate-y-1 active:translate-y-0 transition-all disabled:opacity-50 disabled:hover:translate-y-0"
                        >
                            {isCheckingOut ? "Processing..." : "Secure Checkout"}
                        </button>
                    </div>
                )}
            </div>
        </>
    );
}
