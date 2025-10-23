import { useAuth } from '../contexts/AuthContext';
import { User, Mail, Phone, MapPin } from 'lucide-react';

export function Profile() {
  const { user, userProfile } = useAuth();

  if (!user || !userProfile) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <p className="text-gray-600">Please log in to view your profile</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="bg-white rounded-lg shadow-md p-8">
          <div className="flex items-center mb-8">
            <div className="w-20 h-20 bg-amber-100 rounded-full flex items-center justify-center mr-6">
              <User className="w-10 h-10 text-amber-600" />
            </div>
            <div>
              <h1 className="text-3xl font-bold text-gray-900">
                {userProfile.full_name || 'User Profile'}
              </h1>
              <p className="text-gray-600 capitalize">{userProfile.role}</p>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="flex items-center space-x-3">
              <Mail className="w-5 h-5 text-gray-400" />
              <div>
                <p className="text-sm text-gray-500">Email</p>
                <p className="text-gray-900">{userProfile.email}</p>
              </div>
            </div>

            {userProfile.phone && (
              <div className="flex items-center space-x-3">
                <Phone className="w-5 h-5 text-gray-400" />
                <div>
                  <p className="text-sm text-gray-500">Phone</p>
                  <p className="text-gray-900">{userProfile.phone}</p>
                </div>
              </div>
            )}

            {userProfile.address && (
              <div className="flex items-center space-x-3">
                <MapPin className="w-5 h-5 text-gray-400" />
                <div>
                  <p className="text-sm text-gray-500">Address</p>
                  <p className="text-gray-900">{userProfile.address}</p>
                </div>
              </div>
            )}
          </div>

          <div className="mt-8 pt-8 border-t border-gray-200">
            <h2 className="text-xl font-semibold text-gray-900 mb-4">Recent Activity</h2>
            <p className="text-gray-600">No recent activity</p>
          </div>
        </div>
      </div>
    </div>
  );
}
