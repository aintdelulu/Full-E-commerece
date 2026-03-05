"use client";

import React, { createContext, useContext, useState, useCallback } from "react";
import { X, CheckCircle, AlertCircle, Info } from "lucide-react";

type ToastType = "success" | "error" | "info";

interface Toast {
    id: string;
    message: string;
    type: ToastType;
}

interface ToastContextType {
    toast: (message: string, type?: ToastType) => void;
}

const ToastContext = createContext<ToastContextType | undefined>(undefined);

export const useToast = () => {
    const context = useContext(ToastContext);
    if (!context) {
        throw new Error("useToast must be used within a ToastProvider");
    }
    return context;
};

export const ToastProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const [toasts, setToasts] = useState<Toast[]>([]);

    const removeToast = useCallback((id: string) => {
        setToasts((prev) => prev.filter((t) => t.id !== id));
    }, []);

    const toast = useCallback((message: string, type: ToastType = "success") => {
        const id = Math.random().toString(36).substring(2, 9);
        setToasts((prev) => [...prev, { id, message, type }]);

        // Auto remove after 5 seconds
        setTimeout(() => {
            removeToast(id);
        }, 5000);
    }, [removeToast]);

    return (
        <ToastContext.Provider value={{ toast }}>
            {children}
            <div className="fixed bottom-6 right-6 z-[9999] flex flex-col gap-3 pointer-events-none">
                {toasts.map((t) => (
                    <div
                        key={t.id}
                        className={`
              pointer-events-auto
              flex items-center gap-3 px-5 py-4 rounded-2xl shadow-2xl border min-w-[300px] max-w-md
              animate-in slide-in-from-right-full fade-in duration-300
              ${t.type === "success"
                                ? "bg-[#FFF7EC] border-[#EAD0B8] text-[#8B4513]"
                                : t.type === "error"
                                    ? "bg-red-50 border-red-200 text-red-800"
                                    : "bg-blue-50 border-blue-200 text-blue-800"}
            `}
                    >
                        <div className="flex-shrink-0">
                            {t.type === "success" && <CheckCircle className="w-6 h-6 text-[#D4AF37]" />}
                            {t.type === "error" && <AlertCircle className="w-6 h-6 text-red-500" />}
                            {t.type === "info" && <Info className="w-6 h-6 text-blue-500" />}
                        </div>
                        <p className="font-bold flex-1">{t.message}</p>
                        <button
                            onClick={() => removeToast(t.id)}
                            className="hover:opacity-70 transition-opacity"
                        >
                            <X className="w-5 h-5 opacity-40" />
                        </button>
                    </div>
                ))}
            </div>
        </ToastContext.Provider>
    );
};
