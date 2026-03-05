"use client";

import Image from "next/image";
import Link from "next/link";
import { useCart } from "@/context/CartContext";

export default function Navbar() {
    const { cartCount, toggleCart } = useCart();

    return (
        <nav className="sticky top-0 z-50 w-full bg-background/80 backdrop-blur-md border-b border-border">
            <div className="container mx-auto px-4 h-16 flex items-center justify-between">
                <Link href="/" className="flex items-center gap-3 group">
                    <div className="relative w-10 h-10 overflow-hidden rounded-full border-2 border-primary group-hover:scale-105 transition-transform">
                        <Image
                            src="/assets/logo.jpg"
                            alt="ClickCart Logo"
                            fill
                            className="object-cover"
                        />
                    </div>
                    <span className="text-2xl font-extrabold text-primary tracking-tight">ClickCart</span>
                </Link>
                <div className="flex items-center gap-4">
                    <button className="text-foreground hover:text-primary transition-colors font-medium">
                        Theme
                    </button>
                    <button
                        onClick={toggleCart}
                        className="flex items-center gap-2 bg-primary text-primary-foreground px-5 py-2.5 rounded-full font-bold hover:opacity-90 transition-opacity shadow-sm hover:shadow-primary/20"
                    >
                        Cart ({cartCount})
                    </button>
                </div>
            </div>
        </nav>
    );
}
