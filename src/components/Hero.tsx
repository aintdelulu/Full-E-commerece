import Image from "next/image";

export default function Hero() {
    return (
        <section className="relative w-full h-[70vh] min-h-[500px] flex items-center justify-center overflow-hidden">
            {/* Background Image */}
            <div className="absolute inset-0 z-0">
                <Image
                    src="/assets/bg.jpg"
                    alt="Coffee Beans Background"
                    fill
                    className="object-cover brightness-[0.7] dark:brightness-[0.4]"
                    priority
                />
            </div>

            {/* Content Overlay */}
            <div className="relative z-10 text-center flex flex-col items-center px-4 max-w-4xl mx-auto">
                <h1 className="text-4xl md:text-6xl lg:text-7xl font-extrabold text-[#FFF7EC] tracking-tight mb-6 drop-shadow-xl">
                    A cozy, reliable marketplace.
                </h1>
                <p className="text-lg md:text-2xl text-[#F5EBDD] mb-10 max-w-2xl drop-shadow-lg font-medium">
                    Experience premium coffee, equipment, and apparel. Where aesthetics meet efficiency.
                </p>
                <button className="bg-primary text-primary-foreground px-10 py-4 rounded-full text-lg lg:text-xl font-bold hover:-translate-y-1 hover:scale-105 active:scale-95 transition-all shadow-xl hover:shadow-primary/50">
                    Shop Now
                </button>
            </div>
        </section>
    );
}
