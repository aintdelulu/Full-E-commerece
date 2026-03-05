import { dummyProducts } from "@/data/products";
import Image from "next/image";
import Link from "next/link";
import Header from "@/components/Header";
import AddToCartButton from "./AddToCartButton";

export default async function ProductPage({ params }: { params: { id: string } }) {
    const { id } = await params;
    const product = dummyProducts.find(p => p.id === id);

    if (!product) {
        return (
            <div className="min-h-screen flex flex-col bg-background">
                <Header />
                <div className="flex-1 flex flex-col items-center justify-center p-8">
                    <h1 className="text-4xl font-extrabold text-primary mb-4">Product Not Found</h1>
                    <p className="mb-8 text-foreground/70">The product you are looking for does not exist.</p>
                    <Link href="/" className="bg-primary text-primary-foreground px-6 py-3 rounded-full font-bold">
                        Return Home
                    </Link>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen flex flex-col bg-background">
            <Header />
            <main className="flex-1 py-12 md:py-20">
                <div className="container mx-auto px-4 max-w-6xl">
                    <Link href="/" className="inline-flex items-center text-primary font-bold hover:text-primary/80 mb-8 transition-colors">
                        ← Back to Catalog
                    </Link>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-12 lg:gap-20">
                        {/* Image Gallery */}
                        <div className="relative w-full aspect-square rounded-3xl overflow-hidden bg-secondary border border-border shadow-md">
                            <Image
                                src={product.image}
                                alt={product.name}
                                fill
                                className="object-cover"
                                priority
                            />
                        </div>

                        {/* Product Info */}
                        <div className="flex flex-col">
                            <div className="mb-2">
                                <span className="text-secondary-foreground font-bold tracking-widest text-sm uppercase bg-secondary px-3 py-1 rounded-full">
                                    {product.category}
                                </span>
                            </div>

                            <h1 className="text-4xl md:text-5xl font-extrabold text-foreground mb-4 tracking-tight leading-tight">
                                {product.name}
                            </h1>

                            <p className="text-3xl font-black text-primary mb-6">
                                ${product.price.toFixed(2)}
                            </p>

                            <p className="text-lg text-foreground/80 mb-10 leading-relaxed">
                                {product.description}
                            </p>

                            <div className="mb-10">
                                <h3 className="font-extrabold text-xl mb-4 text-foreground">Details</h3>
                                <ul className="flex flex-col gap-3">
                                    {product.details.map((detail, idx) => (
                                        <li key={idx} className="flex items-start gap-3 text-foreground/80">
                                            <span className="text-primary mt-1">•</span>
                                            <span>{detail}</span>
                                        </li>
                                    ))}
                                </ul>
                            </div>

                            <div className="mt-auto">
                                <AddToCartButton product={product} />
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    );
}
