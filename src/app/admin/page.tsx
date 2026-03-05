"use client";

export const dynamic = 'force-dynamic'

import { useState } from "react";
import Header from "@/components/Header";

export default function AdminDashboard() {
    const [activeTab, setActiveTab] = useState("inventory");

    return (
        <div className="min-h-screen bg-secondary/30 flex flex-col">
            <Header />
            <main className="flex-1 py-10">
                <div className="container mx-auto px-4 max-w-6xl">
                    <h1 className="text-3xl md:text-5xl font-extrabold text-primary mb-10 tracking-tight">Admin Dashboard</h1>

                    <div className="flex gap-4 mb-8 border-b border-border">
                        <button
                            onClick={() => setActiveTab("inventory")}
                            className={`px-4 py-3 font-bold text-lg border-b-4 transition-colors ${activeTab === 'inventory' ? 'border-primary text-primary' : 'border-transparent text-foreground/70 hover:text-foreground'}`}
                        >
                            Inventory Management
                        </button>
                        <button
                            onClick={() => setActiveTab("orders")}
                            className={`px-4 py-3 font-bold text-lg border-b-4 transition-colors ${activeTab === 'orders' ? 'border-primary text-primary' : 'border-transparent text-foreground/70 hover:text-foreground'}`}
                        >
                            Order Tracking
                        </button>
                    </div>

                    {activeTab === "inventory" ? (
                        <div className="bg-card rounded-3xl p-6 md:p-8 shadow-sm border border-border">
                            <div className="flex justify-between items-center mb-6">
                                <h2 className="text-2xl font-bold text-foreground">Current Stock</h2>
                                <button className="bg-primary text-primary-foreground px-6 py-3 rounded-full font-bold hover:bg-primary/90 shadow-sm hover:-translate-y-0.5 transition-transform">
                                    + Add Product
                                </button>
                            </div>
                            <p className="text-foreground/70 mb-8 font-medium">Connect Formspree to fetch and manage live inventory data.</p>

                            <div className="overflow-x-auto rounded-xl border border-border">
                                <table className="w-full text-left border-collapse">
                                    <thead>
                                        <tr className="border-b-2 border-border bg-secondary/50 text-foreground/80">
                                            <th className="py-4 px-6 font-bold">Product Name</th>
                                            <th className="py-4 px-6 font-bold">Category</th>
                                            <th className="py-4 px-6 font-bold">Price</th>
                                            <th className="py-4 px-6 font-bold">Stock</th>
                                            <th className="py-4 px-6 font-bold text-right">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr className="border-b border-border/50 hover:bg-secondary/20 transition-colors">
                                            <td className="py-4 px-6 font-bold text-foreground flex items-center gap-3">
                                                <div className="w-10 h-10 rounded-lg bg-secondary shrink-0"></div>
                                                House Blend Coffee
                                            </td>
                                            <td className="py-4 px-6 text-primary text-sm font-bold uppercase tracking-wider">Brews</td>
                                            <td className="py-4 px-6 font-bold text-lg">$14.99</td>
                                            <td className="py-4 px-6"><span className="bg-green-100 text-green-800 font-bold px-3 py-1 rounded-full text-sm">45 in stock</span></td>
                                            <td className="py-4 px-6 text-right">
                                                <button className="text-primary font-bold hover:underline">Edit</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    ) : (
                        <div className="bg-card rounded-3xl p-6 md:p-8 shadow-sm border border-border">
                            <h2 className="text-2xl font-bold text-foreground mb-4">Recent Orders</h2>
                            <p className="text-foreground/70 mb-8 font-medium">View paid orders from Stripe and manage shipping status.</p>

                            <div className="overflow-x-auto rounded-xl border border-border">
                                <table className="w-full text-left border-collapse">
                                    <thead>
                                        <tr className="border-b-2 border-border bg-secondary/50 text-foreground/80">
                                            <th className="py-4 px-6 font-bold">Order ID</th>
                                            <th className="py-4 px-6 font-bold">Customer</th>
                                            <th className="py-4 px-6 font-bold text-right">Total</th>
                                            <th className="py-4 px-6 font-bold">Status</th>
                                            <th className="py-4 px-6 font-bold text-right">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr className="border-b border-border/50 hover:bg-secondary/20 transition-colors">
                                            <td className="py-4 px-6 font-bold font-mono text-sm">#ORD-9823</td>
                                            <td className="py-4 px-6 font-medium">customer@example.com</td>
                                            <td className="py-4 px-6 font-extrabold text-right">$59.99</td>
                                            <td className="py-4 px-6"><span className="bg-yellow-100 text-yellow-800 font-bold px-3 py-1 rounded-full text-sm">Pending</span></td>
                                            <td className="py-4 px-6 text-right">
                                                <button className="text-primary font-bold hover:underline">Mark Shipped</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    )}
                </div>
            </main>
        </div>
    );
}
