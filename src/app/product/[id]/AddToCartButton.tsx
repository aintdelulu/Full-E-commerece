"use client";

import { useCart } from "@/context/CartContext";

export default function AddToCartButton({ product }: { product: any }) {
    const { addToCart } = useCart();

    return (
        <button
            onClick={() => addToCart({
                id: product.id,
                name: product.name,
                price: product.price,
                image: product.image,
            })}
            className="w-full bg-primary text-primary-foreground py-4 rounded-full font-extrabold text-xl shadow-xl hover:-translate-y-1 hover:shadow-primary/40 active:translate-y-0 transition-all flex items-center justify-center gap-3"
        >
            <span className="text-2xl">+</span> Add to Cart
        </button>
    );
}
