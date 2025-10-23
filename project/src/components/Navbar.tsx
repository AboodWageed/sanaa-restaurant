import { Link, useNavigate } from 'react-router-dom';
import { ShoppingCart, User, LogOut, Menu as MenuIcon, X } from 'lucide-react';
import { useState } from 'react';
import { useAuth } from '../contexts/AuthContext';

export function Navbar() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const { user, userProfile, signOut, isAdmin, isStaff } = useAuth();
  const navigate = useNavigate();

  const handleSignOut = async () => {
    try {
      await signOut();
      navigate('/');
    } catch (error) {
      console.error('Error signing out:', error);
    }
  };

  return (
    <nav className="bg-white shadow-md sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          <Link to="/" className="flex items-center space-x-2">
            <div className="text-2xl font-bold text-amber-600">مطعم صنعاء</div>
            <div className="text-sm text-gray-600">Sana'a Restaurant</div>
          </Link>

          <div className="hidden md:flex items-center space-x-8">
            <Link to="/" className="text-gray-700 hover:text-amber-600 transition">
              Home
            </Link>
            <Link to="/menu" className="text-gray-700 hover:text-amber-600 transition">
              Menu
            </Link>
            <Link to="/reservations" className="text-gray-700 hover:text-amber-600 transition">
              Reservations
            </Link>
            <Link to="/gallery" className="text-gray-700 hover:text-amber-600 transition">
              Gallery
            </Link>
            <Link to="/blog" className="text-gray-700 hover:text-amber-600 transition">
              Blog
            </Link>
            <Link to="/contact" className="text-gray-700 hover:text-amber-600 transition">
              Contact
            </Link>
          </div>

          <div className="hidden md:flex items-center space-x-4">
            <Link to="/cart" className="text-gray-700 hover:text-amber-600 transition">
              <ShoppingCart className="w-6 h-6" />
            </Link>
            {user ? (
              <div className="flex items-center space-x-4">
                <Link
                  to={isAdmin || isStaff ? '/admin' : '/profile'}
                  className="text-gray-700 hover:text-amber-600 transition flex items-center space-x-2"
                >
                  <User className="w-6 h-6" />
                  <span>{userProfile?.full_name || 'Profile'}</span>
                </Link>
                <button
                  onClick={handleSignOut}
                  className="text-gray-700 hover:text-amber-600 transition"
                >
                  <LogOut className="w-6 h-6" />
                </button>
              </div>
            ) : (
              <div className="flex items-center space-x-2">
                <Link
                  to="/login"
                  className="text-amber-600 border border-amber-600 px-4 py-2 rounded-lg hover:bg-amber-50 transition"
                >
                  تسجيل الدخول
                </Link>
                <Link
                  to="/signup"
                  className="bg-amber-600 text-white px-4 py-2 rounded-lg hover:bg-amber-700 transition"
                >
                  إنشاء حساب
                </Link>
              </div>
            )}
          </div>

          <button
            className="md:hidden text-gray-700"
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
          >
            {mobileMenuOpen ? <X className="w-6 h-6" /> : <MenuIcon className="w-6 h-6" />}
          </button>
        </div>
      </div>

      {mobileMenuOpen && (
        <div className="md:hidden bg-white border-t border-gray-200">
          <div className="px-4 py-3 space-y-3">
            <Link
              to="/"
              className="block text-gray-700 hover:text-amber-600 transition"
              onClick={() => setMobileMenuOpen(false)}
            >
              Home
            </Link>
            <Link
              to="/menu"
              className="block text-gray-700 hover:text-amber-600 transition"
              onClick={() => setMobileMenuOpen(false)}
            >
              Menu
            </Link>
            <Link
              to="/reservations"
              className="block text-gray-700 hover:text-amber-600 transition"
              onClick={() => setMobileMenuOpen(false)}
            >
              Reservations
            </Link>
            <Link
              to="/gallery"
              className="block text-gray-700 hover:text-amber-600 transition"
              onClick={() => setMobileMenuOpen(false)}
            >
              Gallery
            </Link>
            <Link
              to="/blog"
              className="block text-gray-700 hover:text-amber-600 transition"
              onClick={() => setMobileMenuOpen(false)}
            >
              Blog
            </Link>
            <Link
              to="/contact"
              className="block text-gray-700 hover:text-amber-600 transition"
              onClick={() => setMobileMenuOpen(false)}
            >
              Contact
            </Link>
            <Link
              to="/cart"
              className="block text-gray-700 hover:text-amber-600 transition"
              onClick={() => setMobileMenuOpen(false)}
            >
              Cart
            </Link>
            {user ? (
              <>
                <Link
                  to={isAdmin || isStaff ? '/admin' : '/profile'}
                  className="block text-gray-700 hover:text-amber-600 transition"
                  onClick={() => setMobileMenuOpen(false)}
                >
                  {userProfile?.full_name || 'Profile'}
                </Link>
                <button
                  onClick={() => {
                    handleSignOut();
                    setMobileMenuOpen(false);
                  }}
                  className="block w-full text-left text-gray-700 hover:text-amber-600 transition"
                >
                  Logout
                </button>
              </>
            ) : (
              <>
                <Link
                  to="/login"
                  className="block text-amber-600 border border-amber-600 px-4 py-2 rounded-lg hover:bg-amber-50 transition text-center"
                  onClick={() => setMobileMenuOpen(false)}
                >
                  تسجيل الدخول
                </Link>
                <Link
                  to="/signup"
                  className="block bg-amber-600 text-white px-4 py-2 rounded-lg hover:bg-amber-700 transition text-center"
                  onClick={() => setMobileMenuOpen(false)}
                >
                  إنشاء حساب
                </Link>
              </>
            )}
          </div>
        </div>
      )}
    </nav>
  );
}
