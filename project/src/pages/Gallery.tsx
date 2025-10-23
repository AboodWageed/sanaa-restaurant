import { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import { GalleryItem } from '../types/database.types';

export function Gallery() {
  const [items, setItems] = useState<GalleryItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchGallery();
  }, []);

  const fetchGallery = async () => {
    try {
      const { data, error } = await supabase
        .from('gallery')
        .select('*')
        .eq('is_active', true)
        .order('display_order');

      if (error) throw error;
      if (data) setItems(data);
    } catch (error) {
      console.error('Error fetching gallery:', error);
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
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">Gallery</h1>
          <p className="text-xl text-amber-600">معرض الصور</p>
        </div>

        {items.length === 0 ? (
          <div className="text-center py-16">
            <p className="text-gray-500 text-lg">No gallery items available.</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {items.map((item) => (
              <div
                key={item.id}
                className="bg-white rounded-lg overflow-hidden shadow-md hover:shadow-xl transition"
              >
                <img
                  src={item.image_url}
                  alt={item.title_en || 'Gallery image'}
                  className="w-full h-64 object-cover"
                />
                {(item.title_en || item.title_ar || item.description_en) && (
                  <div className="p-4">
                    {item.title_en && (
                      <h3 className="text-lg font-semibold text-gray-900">{item.title_en}</h3>
                    )}
                    {item.title_ar && <p className="text-amber-600">{item.title_ar}</p>}
                    {item.description_en && (
                      <p className="text-gray-600 mt-2">{item.description_en}</p>
                    )}
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
