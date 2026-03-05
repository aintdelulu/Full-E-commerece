"use client";

import { useEffect, useRef } from "react";
import { useToast } from "@/context/ToastContext";

interface AuthToastProps {
    message?: string;
    error?: string;
}

export default function AuthToast({ message, error }: AuthToastProps) {
    const { toast } = useToast();
    const lastToastRef = useRef<string | null>(null);

    useEffect(() => {
        // Prevent double toast on hydration
        if (message && lastToastRef.current !== message) {
            toast(message, "success");
            lastToastRef.current = message;
        } else if (error && lastToastRef.current !== error) {
            toast(error, "error");
            lastToastRef.current = error;
        }
    }, [message, error, toast]);

    return null;
}
