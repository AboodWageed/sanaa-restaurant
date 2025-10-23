import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import {
  ShoppingBag,
  Users,
  Calendar,
  MessageSquare,
  TrendingUp,
  DollarSign,
} from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';

export function AdminDashboard() {
  const { isAdmin, isStaff } = useAuth();
  const [stats, setStats] = useState({
    totalOrders: 0,
    totalRevenue: 0,
    totalUsers: 0,
    totalReservations: 0,
    pendingOrders: 0,
    unreadMessages: 0,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (isAdmin || isStaff) {
      fetchStats();
    }
  }, [isAdmin, isStaff]);

  const fetchStats = async () => {
    try {
      const [ordersRes, usersRes, reservationsRes, messagesRes] = await Promise.all([
        supabase.from('orders').select('total_amount, status'),
        supabase.from('users').select('id', { count: 'exact', head: true }),
        supabase.from('reservations').select('id', { count: 'exact', head: true }),
        supabase
          .from('contact_messages')
          .select('id', { count: 'exact', head: true })
          .eq('is_read', false),
      ]);

      if (ordersRes.data) {
        const totalRevenue = ordersRes.data.reduce(
          (sum, order) => sum + (Number(order.total_amount) || 0),
          0
        );
        const pendingOrders = ordersRes.data.filter((o) => o.status === 'pending').length;
        setStats((prev) => ({
          ...prev,
          totalOrders: ordersRes.data.length,
          totalRevenue,
          pendingOrders,
        }));
      }

      setStats((prev) => ({
        ...prev,
        totalUsers: usersRes.count || 0,
        totalReservations: reservationsRes.count || 0,
        unreadMessages: messagesRes.count || 0,
      }));
    } catch (error) {
      console.error('Error fetching stats:', error);
    } finally {
      setLoading(false);
    }
  };

  if (!isAdmin && !isStaff) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-gray-900 mb-4">Access Denied</h1>
          <p className="text-gray-600">You don't have permission to access this page.</p>
        </div>
      </div>
    );
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-amber-600"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">Admin Dashboard</h1>
          <p className="text-gray-600 mt-2">Manage your restaurant operations</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-600 text-sm">Total Orders</p>
                <p className="text-3xl font-bold text-gray-900 mt-2">{stats.totalOrders}</p>
                {stats.pendingOrders > 0 && (
                  <p className="text-amber-600 text-sm mt-1">{stats.pendingOrders} pending</p>
                )}
              </div>
              <div className="w-12 h-12 bg-amber-100 rounded-full flex items-center justify-center">
                <ShoppingBag className="w-6 h-6 text-amber-600" />
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-600 text-sm">Total Revenue</p>
                <p className="text-3xl font-bold text-gray-900 mt-2">
                  {stats.totalRevenue.toFixed(0)} YER
                </p>
              </div>
              <div className="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center">
                <DollarSign className="w-6 h-6 text-green-600" />
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-600 text-sm">Total Users</p>
                <p className="text-3xl font-bold text-gray-900 mt-2">{stats.totalUsers}</p>
              </div>
              <div className="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
                <Users className="w-6 h-6 text-blue-600" />
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-600 text-sm">Reservations</p>
                <p className="text-3xl font-bold text-gray-900 mt-2">{stats.totalReservations}</p>
              </div>
              <div className="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center">
                <Calendar className="w-6 h-6 text-purple-600" />
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-600 text-sm">Unread Messages</p>
                <p className="text-3xl font-bold text-gray-900 mt-2">{stats.unreadMessages}</p>
              </div>
              <div className="w-12 h-12 bg-red-100 rounded-full flex items-center justify-center">
                <MessageSquare className="w-6 h-6 text-red-600" />
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-600 text-sm">Growth</p>
                <p className="text-3xl font-bold text-gray-900 mt-2">+12%</p>
              </div>
              <div className="w-12 h-12 bg-teal-100 rounded-full flex items-center justify-center">
                <TrendingUp className="w-6 h-6 text-teal-600" />
              </div>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <Link
            to="/admin/orders"
            className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition"
          >
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Manage Orders</h3>
            <p className="text-gray-600">View and manage customer orders</p>
          </Link>

          <Link
            to="/admin/menu"
            className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition"
          >
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Menu Management</h3>
            <p className="text-gray-600">Add, edit, and remove menu items</p>
          </Link>

          <Link
            to="/admin/reservations"
            className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition"
          >
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Reservations</h3>
            <p className="text-gray-600">Manage table reservations</p>
          </Link>

          <Link
            to="/admin/users"
            className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition"
          >
            <h3 className="text-lg font-semibold text-gray-900 mb-2">User Management</h3>
            <p className="text-gray-600">Manage customer accounts</p>
          </Link>

          <Link
            to="/admin/messages"
            className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition"
          >
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Contact Messages</h3>
            <p className="text-gray-600">View and respond to messages</p>
          </Link>

          <Link
            to="/admin/settings"
            className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition"
          >
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Settings</h3>
            <p className="text-gray-600">Configure restaurant settings</p>
          </Link>
        </div>
      </div>
    </div>
  );
}
