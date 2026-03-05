import Navbar from "@/components/Navbar";
import AuthButton from "@/components/AuthButton";

export default function Header() {
    return <Navbar auth={<AuthButton />} />;
}
