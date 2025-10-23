import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { Star, Clock, ChefHat } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { MenuItem, Offer, Review, Category } from '../types/database.types';

export function Home() {
  const [featuredItems, setFeaturedItems] = useState<MenuItem[]>([]);
  const [activeOffers, setActiveOffers] = useState<Offer[]>([]);
  const [recentReviews, setRecentReviews] = useState<Review[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchHomeData();
  }, []);

  const fetchHomeData = async () => {
    try {
      const [itemsRes, offersRes, reviewsRes, categoriesRes] = await Promise.all([
        supabase
          .from('menu_items')
          .select('*')
          .eq('is_featured', true)
          .eq('is_available', true)
          .limit(6),
        supabase.from('offers').select('*').eq('is_active', true).limit(3),
        supabase
          .from('reviews')
          .select('*')
          .eq('is_approved', true)
          .order('created_at', { ascending: false })
          .limit(3),
        supabase.from('categories').select('*').eq('is_active', true).order('display_order'),
      ]);

      if (itemsRes.data) setFeaturedItems(itemsRes.data);
      if (offersRes.data) setActiveOffers(offersRes.data);
      if (reviewsRes.data) setRecentReviews(reviewsRes.data);
      if (categoriesRes.data) setCategories(categoriesRes.data);
    } catch (error) {
      console.error('Error fetching home data:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-amber-600"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <section className="relative bg-gradient-to-r from-amber-600 to-amber-700 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24">
          <div className="text-center">
            <h1 className="text-5xl md:text-6xl font-bold mb-6">
              Welcome to Sana'a Restaurant
            </h1>
            <p className="text-xl md:text-2xl mb-4">مرحباً بكم في مطعم صنعاء</p>
            <p className="text-lg mb-8 max-w-2xl mx-auto">
              Experience authentic Yemeni cuisine crafted with traditional recipes and the finest
              ingredients
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Link
                to="/menu"
                className="bg-white text-amber-600 px-8 py-3 rounded-lg font-semibold hover:bg-gray-100 transition"
              >
                View Menu
              </Link>
              <Link
                to="/reservations"
                className="bg-amber-800 text-white px-8 py-3 rounded-lg font-semibold hover:bg-amber-900 transition"
              >
                Make a Reservation
              </Link>
            </div>
          </div>
        </div>
      </section>

      {activeOffers.length > 0 && (
        <section className="py-16 bg-white">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <h2 className="text-3xl font-bold text-gray-900 mb-8 text-center">
              Special Offers
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
              {activeOffers.map((offer) => (
                <div
                  key={offer.id}
                  className="bg-gradient-to-br from-amber-500 to-amber-600 rounded-lg p-6 text-white shadow-lg hover:shadow-xl transition"
                >
                  {offer.image_url && (
                    <img
                      src={offer.image_url}
                      alt={offer.title_en}
                      className="w-full h-48 object-cover rounded-lg mb-4"
                    />
                  )}
                  <h3 className="text-2xl font-bold mb-2">{offer.title_en}</h3>
                  <p className="text-amber-100 mb-2">{offer.title_ar}</p>
                  <p className="text-white mb-4">{offer.description_en}</p>
                  {offer.discount_percentage && (
                    <div className="text-3xl font-bold">{offer.discount_percentage}% OFF</div>
                  )}
                </div>
              ))}
            </div>
          </div>
        </section>
      )}

      {categories.length > 0 && (
        <section className="py-16 bg-gray-50">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <h2 className="text-3xl font-bold text-gray-900 mb-8 text-center">
              Browse Categories
            </h2>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
              {categories.map((category) => (
                <Link
                  key={category.id}
                  to={`/menu?category=${category.id}`}
                  className="bg-white rounded-lg p-6 text-center shadow-md hover:shadow-xl transition"
                >
                  {category.image_url && (
                    <img
                      src={category.image_url}
                      alt={category.name_en}
                      className="w-full h-32 object-cover rounded-lg mb-4"
                    />
                  )}
                  <h3 className="text-lg font-semibold text-gray-900">{category.name_en}</h3>
                  <p className="text-amber-600">{category.name_ar}</p>
                </Link>
              ))}
            </div>
          </div>
        </section>
      )}

      {featuredItems.length > 0 && (
        <section className="py-16 bg-white">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <h2 className="text-3xl font-bold text-gray-900 mb-8 text-center">
              Featured Dishes
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
              {featuredItems.map((item) => (
                <div
                  key={item.id}
                  className="bg-gray-50 rounded-lg overflow-hidden shadow-md hover:shadow-xl transition"
                >
                  {item.image_url && (
                    <img
                      src={item.image_url}
                      alt={item.name_en}
                      className="w-full h-48 object-cover"
                    />
                  )}
                  <div className="p-6">
                    <h3 className="text-xl font-bold text-gray-900 mb-2">{item.name_en}</h3>
                    <p className="text-amber-600 mb-2">{item.name_ar}</p>
                    <p className="text-gray-600 mb-4 line-clamp-2">{item.description_en}</p>
                    <div className="flex items-center justify-between">
                      <span className="text-2xl font-bold text-amber-600">
                        {item.price} YER
                      </span>
                      <div className="flex items-center text-gray-500 text-sm">
                        <Clock className="w-4 h-4 mr-1" />
                        <span>{item.preparation_time} min</span>
                      </div>
                    </div>
                    <Link
                      to={`/menu/${item.id}`}
                      className="mt-4 block w-full bg-amber-600 text-white text-center py-2 rounded-lg hover:bg-amber-700 transition"
                    >
                      Order Now
                    </Link>
                  </div>
                </div>
              ))}
            </div>
            <div className="text-center mt-8">
              <Link
                to="/menu"
                className="inline-block bg-amber-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-amber-700 transition"
              >
                View Full Menu
              </Link>
            </div>
          </div>
        </section>
      )}

      <section className="py-16 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-bold text-gray-900 mb-8 text-center">Why Choose Us</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="bg-white rounded-lg p-8 text-center shadow-md">
              <div className="w-16 h-16 bg-amber-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <ChefHat className="w-8 h-8 text-amber-600" />
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">Expert Chefs</h3>
              <p className="text-gray-600">
                Our experienced chefs bring authentic Yemeni flavors to every dish
              </p>
            </div>
            <div className="bg-white rounded-lg p-8 text-center shadow-md">
              <div className="w-16 h-16 bg-amber-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <Star className="w-8 h-8 text-amber-600" />
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">Quality Ingredients</h3>
              <p className="text-gray-600">
                We use only the freshest and highest quality ingredients
              </p>
            </div>
            <div className="bg-white rounded-lg p-8 text-center shadow-md">
              <div className="w-16 h-16 bg-amber-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <Clock className="w-8 h-8 text-amber-600" />
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">Fast Service</h3>
              <p className="text-gray-600">Quick preparation and delivery without compromising quality</p>
            </div>
          </div>
        </div>
      </section>

      {recentReviews.length > 0 && (
        <section className="py-16 bg-white">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <h2 className="text-3xl font-bold text-gray-900 mb-8 text-center">
              Customer Reviews
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
              {recentReviews.map((review) => (
                <div key={review.id} className="bg-gray-50 rounded-lg p-6 shadow-md">
                  <div className="flex items-center mb-4">
                    {[...Array(5)].map((_, i) => (
                      <Star
                        key={i}
                        className={`w-5 h-5 ${
                          i < review.rating ? 'text-amber-500 fill-amber-500' : 'text-gray-300'
                        }`}
                      />
                    ))}
                  </div>
                  <p className="text-gray-700 mb-4">{review.comment}</p>
                  <p className="text-sm text-gray-500">
                    {new Date(review.created_at).toLocaleDateString()}
                  </p>
                </div>
              ))}
            </div>
          </div>
        </section>
      )}
    </div>
  );
}
