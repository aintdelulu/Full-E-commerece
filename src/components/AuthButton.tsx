'use client'

import { createClient } from '@/utils/supabase/client'
import { signout } from '@/app/login/actions'
import Link from 'next/link'
import { useEffect, useState } from 'react'
import { User } from '@supabase/supabase-js'

export default function AuthButton() {
    const [user, setUser] = useState<User | null>(null)
    const [loading, setLoading] = useState(true)
    const supabase = createClient()

    useEffect(() => {
        const getUser = async () => {
            const { data: { user } } = await supabase.auth.getUser()
            setUser(user)
            setLoading(false)
        }

        getUser()

        const { data: { subscription } } = supabase.auth.onAuthStateChange(
            (event, session) => {
                setUser(session?.user ?? null)
            }
        )

        return () => subscription.unsubscribe()
    }, [supabase.auth])

    if (loading) {
        return <div className="w-20 h-8 bg-secondary rounded-full animate-pulse"></div>
    }

    return user ? (
        <div className="flex items-center gap-4">
            <Link href="/account" className="text-foreground hover:text-primary font-bold text-sm transition-colors hidden sm:block">
                Hi, {user.email?.split('@')[0]}
            </Link>
            <form action={signout}>
                <button className="text-secondary-foreground hover:text-red-500 font-bold text-sm bg-secondary px-4 py-2 rounded-full hover:bg-red-50 transition-colors">
                    Log out
                </button>
            </form>
        </div>
    ) : (
        <Link
            href="/login"
            className="text-primary hover:text-primary/80 font-bold border-2 border-primary px-5 py-2 rounded-full hover:bg-primary/5 transition-colors"
        >
            Login
        </Link>
    )
}
