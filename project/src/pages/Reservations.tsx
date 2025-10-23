import { useState } from 'react';
import { Calendar, Clock, Users } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { useNavigate } from 'react-router-dom';

export function Reservations() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    reservation_date: '',
    reservation_time: '',
    party_size: 2,
    special_requests: '',
  });
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!user) {
      navigate('/login');
      return;
    }

    setLoading(true);
    setError('');
    setSuccess(false);

    try {
      const { error: submitError } = await supabase.from('reservations').insert([
        {
          user_id: user.id,
          ...formData,
          status: 'pending',
        },
      ]);

      if (submitError) throw submitError;

      setSuccess(true);
      setFormData({
        reservation_date: '',
        reservation_time: '',
        party_size: 2,
        special_requests: '',
      });
    } catch (err: any) {
      setError(err.message || 'Failed to create reservation');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">Make a Reservation</h1>
          <p className="text-xl text-amber-600">احجز طاولتك</p>
        </div>

        <div className="bg-white rounded-lg shadow-md p-8">
          {success && (
            <div className="mb-6 p-4 bg-green-100 border border-green-400 text-green-700 rounded">
              Your reservation has been submitted successfully! We will confirm it shortly.
            </div>
          )}

          {error && (
            <div className="mb-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-6">
            <div>
              <label htmlFor="date" className="block text-sm font-medium text-gray-700 mb-2">
                <Calendar className="w-4 h-4 inline mr-2" />
                Reservation Date
              </label>
              <input
                id="date"
                type="date"
                required
                min={new Date().toISOString().split('T')[0]}
                value={formData.reservation_date}
                onChange={(e) =>
                  setFormData({ ...formData, reservation_date: e.target.value })
                }
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500 focus:border-transparent"
              />
            </div>

            <div>
              <label htmlFor="time" className="block text-sm font-medium text-gray-700 mb-2">
                <Clock className="w-4 h-4 inline mr-2" />
                Reservation Time
              </label>
              <input
                id="time"
                type="time"
                required
                value={formData.reservation_time}
                onChange={(e) =>
                  setFormData({ ...formData, reservation_time: e.target.value })
                }
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500 focus:border-transparent"
              />
            </div>

            <div>
              <label htmlFor="party_size" className="block text-sm font-medium text-gray-700 mb-2">
                <Users className="w-4 h-4 inline mr-2" />
                Number of Guests
              </label>
              <input
                id="party_size"
                type="number"
                required
                min="1"
                max="20"
                value={formData.party_size}
                onChange={(e) =>
                  setFormData({ ...formData, party_size: parseInt(e.target.value) })
                }
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500 focus:border-transparent"
              />
            </div>

            <div>
              <label
                htmlFor="special_requests"
                className="block text-sm font-medium text-gray-700 mb-2"
              >
                Special Requests (Optional)
              </label>
              <textarea
                id="special_requests"
                rows={4}
                value={formData.special_requests}
                onChange={(e) =>
                  setFormData({ ...formData, special_requests: e.target.value })
                }
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500 focus:border-transparent"
                placeholder="Any special requirements or requests..."
              />
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-amber-600 text-white py-3 rounded-lg font-semibold hover:bg-amber-700 transition disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? 'Submitting...' : 'Reserve Table'}
            </button>
          </form>

          <div className="mt-8 bg-amber-50 rounded-lg p-6">
            <h3 className="font-semibold text-gray-900 mb-4">Reservation Policy</h3>
            <ul className="space-y-2 text-gray-600 text-sm">
              <li>• Reservations must be made at least 2 hours in advance</li>
              <li>• Please arrive within 15 minutes of your reservation time</li>
              <li>• For parties larger than 10, please call us directly</li>
              <li>• Cancellations should be made at least 1 hour before the reservation time</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
}
