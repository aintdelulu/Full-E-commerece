"use client";

import { useState } from "react";
import Image from "next/image";
import Link from "next/link";
import { useCart } from "@/context/CartContext";
import { dummyProducts } from "@/data/products";

const CATEGORIES = ["All", "Brews", "Equipment", "Apparel"];

export default function ProductCatalog() {
    const [activeCategory, setActiveCategory] = useState("All");
    const [searchQuery, setSearchQuery] = useState("");
    const { addToCart } = useCart();

    const filteredProducts = dummyProducts.filter((product) => {
        const matchesCategory = activeCategory === "All" || product.category === activeCategory;
        const matchesSearch = product.name.toLowerCase().includes(searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
    });

    return (
        <section className="py-24 bg-background border-t-4 border-primary/20">
            <div className="container mx-auto px-4 max-w-7xl">
                <div className="flex flex-col md:flex-row justify-between items-end mb-16 gap-8">
                    <div className="max-w-xl">
                        <h2 className="text-4xl md:text-5xl font-extrabold text-primary mb-6 tracking-tight">Our Collection</h2>
                        <p className="text-xl text-foreground/80 leading-relaxed font-medium">
                            Carefully curated. Perfectly roasted. Discover the tools and beans to elevate your daily ritual.
                        </p>
                    </div>

                    <div className="flex flex-col sm:flex-row gap-4 w-full md:w-auto">
                        <input
                            type="text"
                            placeholder="Search our collection..."
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                            className="bg-card border-2 border-border/50 text-foreground px-6 py-4 rounded-2xl focus:outline-none focus:ring-4 focus:ring-primary/20 transition-all font-medium placeholder:text-foreground/40 w-full sm:w-64"
                        />
                    </div>
                </div>

                {/* Categories */}
                <div className="flex flex-wrap gap-3 mb-12">
                    {CATEGORIES.map((category) => (
                        <button
                            key={category}
                            onClick={() => setActiveCategory(category)}
                            className={`px-6 py-2.5 rounded-full font-bold text-sm transition-all shadow-sm ${activeCategory === category
                                ? "bg-primary text-primary-foreground hover:bg-primary/90 scale-105"
                                : "bg-card text-foreground border border-border hover:border-primary/50 hover:bg-secondary/50"
                                }`}
                        >
                            {category}
                        </button>
                    ))}
                </div>

                {/* Product Grid */}
                {filteredProducts.length > 0 ? (
                    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">
                        {filteredProducts.map((product) => (
                            <div key={product.id} className="bg-card rounded-3xl overflow-hidden shadow-sm hover:shadow-xl transition-all duration-300 border border-border group flex flex-col hover:-translate-y-1">
                                <Link href={`/product/${product.id}`} className="relative h-60 w-full overflow-hidden bg-secondary block">
                                    <Image
                                        src={product.image}
                                        alt={product.name}
                                        fill
                                        className="object-cover group-hover:scale-110 transition-transform duration-700 ease-in-out"
                                        sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw"
                                    />
                                    <div className="absolute inset-0 bg-primary/0 group-hover:bg-primary/10 transition-colors duration-300 mix-blend-overlay"></div>
                                </Link>
                                <div className="p-6 flex flex-col flex-1">
                                    <span className="text-xs font-bold text-primary/70 uppercase tracking-widest mb-2">
                                        {product.category}
                                    </span>
                                    <Link href={`/product/${product.id}`} className="block">
                                        <h3 className="text-xl font-extrabold text-card-foreground mb-4 flex-1 leading-snug group-hover:text-primary transition-colors">
                                            {product.name}
                                        </h3>
                                    </Link>
                                    <div className="flex items-center justify-between mt-auto">
                                        <span className="text-2xl font-black text-foreground">
                                            ${product.price.toFixed(2)}
                                        </span>
                                        <button
                                            onClick={() => addToCart({
                                                id: product.id,
                                                name: product.name,
                                                price: product.price,
                                                image: product.image
                                            })}
                                            className="bg-secondary text-secondary-foreground w-12 h-12 rounded-full flex items-center justify-center hover:bg-primary hover:text-primary-foreground transition-all duration-300 transform group-hover:scale-110 group-hover:shadow-md font-bold text-xl"
                                        >
                                            +
                                        </button>
                                    </div>
                                </div>
                            </div>
                        ))}
                    </div>
                ) : (
                    <div className="text-center py-20 bg-secondary/20 rounded-3xl border-2 border-dashed border-border/50">
                        <p className="text-xl text-foreground/70 font-medium">No products found matching your criteria.</p>
                    </div>
                )}
            </div>
        </section>
    );
}
