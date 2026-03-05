import { createBrowserClient } from '@supabase/ssr'

export function createClient() {
    return createBrowserClient(
        (process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://placeholder.supabase.co').replace(/"/g, ''),
        (process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || 'placeholder').replace(/"/g, '')
    )
}
