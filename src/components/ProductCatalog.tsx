"use client";

import { useState } from "react";
import Image from "next/image";
import { useCart } from "@/context/CartContext";

// Dummy data for MVP phase before Supabase connection
const DUMMY_PRODUCTS = [
    { id: "1", name: "House Blend Coffee", category: "Brews", price: 14.99, image: "https://images.unsplash.com/photo-1559525839-b184a4d698c7?w=500&auto=format&fit=crop&q=60" },
    { id: "2", name: "Espresso Roast", category: "Brews", price: 16.99, image: "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500&auto=format&fit=crop&q=60" },
    { id: "3", name: "Pour Over Kit", category: "Equipment", price: 45.00, image: "https://images.unsplash.com/photo-1495474472207-464a8d9cb907?w=500&auto=format&fit=crop&q=60" },
    { id: "4", name: "Ceramic Mug", category: "Equipment", price: 12.00, image: "https://images.unsplash.com/photo-1517256064527-09c73fc5e8e8?w=500&auto=format&fit=crop&q=60" },
    { id: "5", name: "Barista Apron", category: "Apparel", price: 35.00, image: "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=500&auto=format&fit=crop&q=60" },
    { id: "6", name: "ClickCart Cap", category: "Apparel", price: 18.00, image: "https://images.unsplash.com/photo-1521369909029-2afed882baee?w=500&auto=format&fit=crop&q=60" }
];

const CATEGORIES = ["All", "Brews", "Equipment", "Apparel"];

export default function ProductCatalog() {
    const [activeCategory, setActiveCategory] = useState("All");
    const [searchQuery, setSearchQuery] = useState("");
    const { addToCart } = useCart();

    const filteredProducts = DUMMY_PRODUCTS.filter((product) => {
        const matchesCategory = activeCategory === "All" || product.category === activeCategory;
        const matchesSearch = product.name.toLowerCase().includes(searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
    });

    return (
        <section className="container mx-auto px-4 py-16">
            <div className="flex flex-col md:flex-row justify-between items-center mb-8 gap-4">
                <h2 className="text-3xl font-extrabold text-primary tracking-tight">Our Offerings</h2>

                {/* Search Bar */}
                <div className="relative w-full md:w-72">
                    <input
                        type="text"
                        placeholder="Search products..."
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                        className="w-full px-5 py-2.5 rounded-full border border-border bg-card text-card-foreground focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent shadow-sm transition-all"
                    />
                </div>
            </div>

            {/* Filters */}
            <div className="flex flex-wrap gap-2 mb-10">
                {CATEGORIES.map((category) => (
                    <button
                        key={category}
                        onClick={() => setActiveCategory(category)}
                        className={`px-5 py-2 rounded-full font-bold text-sm transition-all shadow-sm ${activeCategory === category
                                ? "bg-primary text-primary-foreground hover:bg-primary/90 scale-105"
                                : "bg-secondary text-secondary-foreground hover:bg-border"
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
                            <div className="relative h-60 w-full overflow-hidden bg-secondary">
                                <Image
                                    src={product.image}
                                    alt={product.name}
                                    fill
                                    className="object-cover group-hover:scale-110 transition-transform duration-700 ease-in-out"
                                    sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw"
                                />
                                <div className="absolute inset-0 bg-primary/0 group-hover:bg-primary/10 transition-colors duration-300 mix-blend-overlay"></div>
                            </div>
                            <div className="p-6 flex flex-col flex-1">
                                <span className="text-xs font-bold text-primary/70 uppercase tracking-widest mb-2">
                                    {product.category}
                                </span>
                                <h3 className="text-xl font-extrabold text-card-foreground mb-4 flex-1 leading-snug">
                                    {product.name}
                                </h3>
                                <div className="flex items-center justify-between mt-auto">
                                    <span className="text-2xl font-black text-foreground">
                                        ${product.price.toFixed(2)}
                                    </span>
                                    <button
                                        onClick={() => addToCart(product)}
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
        </section>
    );
}
