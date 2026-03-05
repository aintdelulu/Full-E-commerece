import { NextResponse } from "next/server";
import Stripe from "stripe";

// Note: Replace with actual secret key in .env.local
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY || "sk_test_placeholder", {
    apiVersion: "2023-10-16" as any,
});

export async function POST(req: Request) {
    try {
        const { items } = await req.json();

        if (!process.env.STRIPE_SECRET_KEY || process.env.STRIPE_SECRET_KEY === "sk_test_placeholder") {
            return NextResponse.json(
                { error: "Stripe Secret Key is not configured in Vercel environment variables." },
                { status: 500 }
            );
        }

        if (!items || items.length === 0) {
            return NextResponse.json({ error: "Cart is empty" }, { status: 400 });
        }

        // Format line items for Stripe Checkout
        const lineItems = items.map((item: any) => ({
            price_data: {
                currency: "usd",
                product_data: {
                    name: item.name,
                    images: [item.image],
                },
                unit_amount: Math.round(item.price * 100), // Stripe expects cents
            },
            quantity: item.quantity,
        }));

        // Create Checkout Session
        const session = await stripe.checkout.sessions.create({
            payment_method_types: ["card"],
            line_items: lineItems,
            mode: "payment",
            success_url: `${process.env.NEXT_PUBLIC_APP_URL || "http://localhost:3000"}/success?session_id={CHECKOUT_SESSION_ID}`,
            cancel_url: `${process.env.NEXT_PUBLIC_APP_URL || "http://localhost:3000"}/?canceled=true`,
        });

        return NextResponse.json({ id: session.id, url: session.url });
    } catch (error: any) {
        console.error("Error creating checkout session:", error);
        return NextResponse.json(
            { error: error?.message || "Error creating checkout session" },
            { status: 500 }
        );
    }
}
