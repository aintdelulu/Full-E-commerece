import { login, signup } from './actions'
import Header from '@/components/Header'
import Link from 'next/link'

export default function LoginPage({
    searchParams,
}: {
    searchParams: { message: string, error: string }
}) {
    return (
        <div className="min-h-screen flex flex-col bg-background">
            <Header />
            <div className="flex-1 flex flex-col justify-center items-center px-4">
                <div className="w-full max-w-md bg-card border border-border rounded-3xl p-8 shadow-sm">
                    <h1 className="text-3xl font-extrabold text-primary mb-6 text-center tracking-tight">
                        Welcome to ClickCart
                    </h1>

                    <form className="flex flex-col gap-4">
                        <div className="flex flex-col gap-2">
                            <label className="text-sm font-bold text-foreground" htmlFor="email">
                                Email
                            </label>
                            <input
                                className="rounded-xl px-4 py-3 bg-secondary/50 border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                                name="email"
                                type="email"
                                placeholder="you@example.com"
                                required
                            />
                        </div>
                        <div className="flex flex-col gap-2">
                            <label className="text-sm font-bold text-foreground" htmlFor="password">
                                Password
                            </label>
                            <input
                                className="rounded-xl px-4 py-3 bg-secondary/50 border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                                type="password"
                                name="password"
                                placeholder="••••••••"
                                required
                            />
                        </div>

                        <div className="mt-4 flex flex-col gap-3">
                            <button
                                formAction={login}
                                className="w-full bg-primary text-primary-foreground font-bold py-3 px-4 rounded-xl hover:-translate-y-0.5 transition-transform shadow-md hover:shadow-primary/30"
                            >
                                Sign In
                            </button>
                            <button
                                formAction={signup}
                                className="w-full bg-secondary text-secondary-foreground font-bold py-3 px-4 rounded-xl hover:bg-border transition-colors"
                            >
                                Create Account
                            </button>
                            <Link
                                href="/"
                                className="w-full bg-transparent border-2 border-border text-foreground text-center font-bold py-3 px-4 rounded-xl hover:bg-secondary/50 transition-colors mt-2"
                            >
                                Continue as Guest
                            </Link>
                        </div>

                        {searchParams?.error && (
                            <div className="mt-4 p-4 bg-red-100 text-red-800 rounded-xl text-center font-medium text-sm">
                                {searchParams.error}
                            </div>
                        )}

                        {searchParams?.message && (
                            <div className="mt-4 p-4 bg-green-100 text-green-800 rounded-xl text-center font-medium text-sm">
                                {searchParams.message}
                            </div>
                        )}
                    </form>
                </div>
            </div>
        </div>
    )
}
