"use client";

import Image from "next/image";
import Link from "next/link";
import { useCart } from "@/context/CartContext";

export default function Navbar({ auth }: { auth?: React.ReactNode }) {
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
                    <span className="text-2xl font-extrabold text-primary tracking-tight hidden sm:block">ClickCart</span>
                </Link>
                <div className="flex items-center gap-2 sm:gap-4">
                    {/* Search Bar Placeholder */}
                    <div className="hidden md:block flex-1 max-w-md mx-4">
                        <input
                            type="text"
                            placeholder="Search Marketplace..."
                            className="w-full px-4 py-2 rounded-full border border-border bg-card text-card-foreground focus:outline-none focus:ring-2 focus:ring-primary shadow-sm"
                        />
                    </div>

                    {auth}

                    <button className="text-foreground hover:text-primary transition-colors font-medium hidden sm:block">
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
