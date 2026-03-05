import Link from "next/link";
import Image from "next/image";

export default function Footer() {
    return (
        <footer className="bg-card border-t border-border mt-auto w-full">
            <div className="container mx-auto px-4 py-12 md:py-16">
                <div className="grid grid-cols-1 md:grid-cols-4 gap-8 md:gap-12">
                    <div className="md:col-span-1 flex flex-col items-start">
                        <Link href="/" className="flex items-center gap-3 group mb-6">
                            <div className="relative w-10 h-10 overflow-hidden rounded-full border-2 border-primary">
                                <Image
                                    src="/assets/logo.jpg"
                                    alt="ClickCart Logo"
                                    fill
                                    className="object-cover"
                                />
                            </div>
                            <span className="text-2xl font-extrabold text-primary tracking-tight">ClickCart</span>
                        </Link>
                        <p className="text-foreground/80 font-medium mb-6 leading-relaxed">
                            A cozy, reliable marketplace where aesthetics meet efficiency. Coffee & Cream vibes every single day.
                        </p>
                    </div>

                    <div>
                        <h3 className="font-extrabold text-foreground text-lg mb-4">Marketplace</h3>
                        <ul className="flex flex-col gap-3 font-medium text-foreground/70">
                            <li><Link href="#" className="hover:text-primary transition-colors">All Products</Link></li>
                            <li><Link href="#" className="hover:text-primary transition-colors">Fresh Brews</Link></li>
                            <li><Link href="#" className="hover:text-primary transition-colors">Premium Equipment</Link></li>
                            <li><Link href="#" className="hover:text-primary transition-colors">Apparel & Merch</Link></li>
                        </ul>
                    </div>

                    <div>
                        <h3 className="font-extrabold text-foreground text-lg mb-4">My Account</h3>
                        <ul className="flex flex-col gap-3 font-medium text-foreground/70">
                            <li><Link href="/login" className="hover:text-primary transition-colors">Sign In / Register</Link></li>
                            <li><Link href="/account" className="hover:text-primary transition-colors">My Profile</Link></li>
                            <li><Link href="/account" className="hover:text-primary transition-colors">Order History</Link></li>
                            <li><Link href="#" className="hover:text-primary transition-colors">Wishlist</Link></li>
                        </ul>
                    </div>

                    <div>
                        <h3 className="font-extrabold text-foreground text-lg mb-4">Support</h3>
                        <ul className="flex flex-col gap-3 font-medium text-foreground/70">
                            <li><Link href="#" className="hover:text-primary transition-colors">Contact Us</Link></li>
                            <li><Link href="#" className="hover:text-primary transition-colors">Shipping & Returns</Link></li>
                            <li><Link href="#" className="hover:text-primary transition-colors">Privacy Policy</Link></li>
                            <li><Link href="#" className="hover:text-primary transition-colors">Terms of Service</Link></li>
                        </ul>
                    </div>
                </div>

                <div className="border-t border-border mt-12 pt-8 flex flex-col md:flex-row items-center justify-between text-sm font-bold text-foreground/50">
                    <p>© {new Date().getFullYear()} ClickCart. All rights reserved.</p>
                    <div className="flex gap-4 mt-4 md:mt-0">
                        <Link href="#" className="hover:text-primary transition-colors">Twitter</Link>
                        <Link href="#" className="hover:text-primary transition-colors">Instagram</Link>
                        <Link href="#" className="hover:text-primary transition-colors">GitHub</Link>
                    </div>
                </div>
            </div>
        </footer>
    );
}
