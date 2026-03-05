import Link from "next/link";
import { Suspense } from "react";
import Header from "@/components/Header";

function SuccessContent() {
    return (
        <div className="flex flex-col items-center justify-center min-h-[70vh] text-center px-4">
            <div className="w-24 h-24 bg-green-100 text-green-600 rounded-full flex items-center justify-center text-5xl mb-8 shadow-sm">
                ✓
            </div>
            <h1 className="text-4xl md:text-5xl font-extrabold text-primary mb-4 tracking-tight">
                Payment Successful!
            </h1>
            <p className="text-xl text-foreground/80 mb-8 max-w-lg">
                Thank you for your order. We are getting your items ready for shipment. A receipt has been sent to your email.
            </p>
            <Link
                href="/"
                className="bg-primary text-primary-foreground px-8 py-4 rounded-full font-bold text-lg hover:-translate-y-1 active:translate-y-0 transition-transform shadow-lg hover:shadow-primary/50"
            >
                Return to Store
            </Link>
        </div>
    );
}

export default function SuccessPage() {
    return (
        <div className="min-h-screen flex flex-col">
            <Header />
            <main className="flex-1">
                <Suspense fallback={<div className="text-center mt-20 font-bold text-xl text-primary">Confirming your order...</div>}>
                    <SuccessContent />
                </Suspense>
            </main>
        </div>
    );
}
