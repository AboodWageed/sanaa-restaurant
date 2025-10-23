import { Link } from 'react-router-dom';
import { ShoppingCart } from 'lucide-react';

export function Cart() {
  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">Shopping Cart</h1>
          <p className="text-xl text-amber-600">سلة التسوق</p>
        </div>

        <div className="bg-white rounded-lg shadow-md p-8 text-center">
          <ShoppingCart className="w-16 h-16 text-gray-400 mx-auto mb-4" />
          <h2 className="text-2xl font-semibold text-gray-900 mb-4">Your cart is empty</h2>
          <p className="text-gray-600 mb-8">
            Start adding delicious items from our menu to your cart!
          </p>
          <Link
            to="/menu"
            className="inline-block bg-amber-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-amber-700 transition"
          >
            Browse Menu
          </Link>
        </div>
      </div>
    </div>
  );
}
