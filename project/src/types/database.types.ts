export type UserRole = 'customer' | 'admin' | 'staff';
export type StaffStatus = 'active' | 'inactive';
export type OrderStatus = 'pending' | 'confirmed' | 'preparing' | 'ready' | 'delivered' | 'cancelled';
export type PaymentMethod = 'cash' | 'card' | 'online';
export type PaymentStatus = 'pending' | 'paid' | 'refunded';
export type ReservationStatus = 'pending' | 'confirmed' | 'cancelled' | 'completed';
export type NotificationType = 'order' | 'reservation' | 'promotion' | 'system';
export type DiscountType = 'percentage' | 'fixed';

export interface User {
  id: string;
  email: string;
  full_name?: string;
  phone?: string;
  address?: string;
  role: UserRole;
  created_at: string;
  updated_at: string;
}

export interface Staff {
  id: string;
  user_id: string;
  position: string;
  hire_date: string;
  salary: number;
  status: StaffStatus;
  created_at: string;
}

export interface Category {
  id: string;
  name_en: string;
  name_ar: string;
  description_en?: string;
  description_ar?: string;
  image_url?: string;
  display_order: number;
  is_active: boolean;
  created_at: string;
}

export interface MenuItem {
  id: string;
  category_id: string;
  name_en: string;
  name_ar: string;
  description_en?: string;
  description_ar?: string;
  price: number;
  image_url?: string;
  is_available: boolean;
  is_featured: boolean;
  preparation_time: number;
  calories?: number;
  created_at: string;
  updated_at: string;
}

export interface Order {
  id: string;
  user_id: string;
  order_number: string;
  total_amount: number;
  status: OrderStatus;
  payment_method: PaymentMethod;
  payment_status: PaymentStatus;
  delivery_address?: string;
  delivery_fee: number;
  notes?: string;
  created_at: string;
  updated_at: string;
}

export interface OrderItem {
  id: string;
  order_id: string;
  menu_item_id: string;
  quantity: number;
  unit_price: number;
  subtotal: number;
  notes?: string;
}

export interface OrderTracking {
  id: string;
  order_id: string;
  status: string;
  notes?: string;
  created_at: string;
}

export interface Reservation {
  id: string;
  user_id: string;
  reservation_date: string;
  reservation_time: string;
  party_size: number;
  status: ReservationStatus;
  special_requests?: string;
  created_at: string;
}

export interface Review {
  id: string;
  user_id: string;
  order_id?: string;
  rating: number;
  comment?: string;
  is_approved: boolean;
  created_at: string;
}

export interface Notification {
  id: string;
  user_id: string;
  title: string;
  message: string;
  type: NotificationType;
  is_read: boolean;
  created_at: string;
}

export interface BlogPost {
  id: string;
  author_id: string;
  title_en: string;
  title_ar: string;
  content_en: string;
  content_ar: string;
  image_url?: string;
  is_published: boolean;
  published_at?: string;
  created_at: string;
}

export interface GalleryItem {
  id: string;
  title_en?: string;
  title_ar?: string;
  image_url: string;
  description_en?: string;
  description_ar?: string;
  display_order: number;
  is_active: boolean;
  created_at: string;
}

export interface Offer {
  id: string;
  title_en: string;
  title_ar: string;
  description_en?: string;
  description_ar?: string;
  discount_percentage?: number;
  image_url?: string;
  start_date: string;
  end_date: string;
  is_active: boolean;
  created_at: string;
}

export interface Coupon {
  id: string;
  code: string;
  discount_type: DiscountType;
  discount_value: number;
  min_order_amount: number;
  max_uses?: number;
  used_count: number;
  start_date: string;
  end_date: string;
  is_active: boolean;
  created_at: string;
}

export interface Settings {
  id: string;
  key: string;
  value?: string;
  description?: string;
  updated_at: string;
}

export interface ContactMessage {
  id: string;
  name: string;
  email: string;
  phone?: string;
  subject: string;
  message: string;
  is_read: boolean;
  created_at: string;
}


// Advanced Features Types

export type TableStatus = 'available' | 'occupied' | 'reserved' | 'maintenance';
export type PaymentGatewayStatus = 'pending' | 'completed' | 'failed' | 'refunded';
export type LoyaltyTier = 'bronze' | 'silver' | 'gold' | 'platinum';
export type LoyaltyTransactionType = 'earned' | 'redeemed' | 'expired' | 'adjusted';
export type InventoryMovementType = 'in' | 'out' | 'adjustment' | 'waste';

export interface Table {
  id: string;
  table_number: string;
  capacity: number;
  location?: string;
  status: TableStatus;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface Payment {
  id: string;
  order_id: string;
  amount: number;
  payment_method: PaymentMethod;
  payment_status: PaymentGatewayStatus;
  transaction_id?: string;
  gateway_response?: any;
  refund_amount?: number;
  refund_reason?: string;
  processed_by?: string;
  notes?: string;
  created_at: string;
  updated_at: string;
}

export interface LoyaltyAccount {
  id: string;
  user_id: string;
  points_balance: number;
  total_points_earned: number;
  total_points_redeemed: number;
  tier: LoyaltyTier;
  created_at: string;
  updated_at: string;
}

export interface LoyaltyTransaction {
  id: string;
  loyalty_account_id: string;
  order_id?: string;
  points: number;
  transaction_type: LoyaltyTransactionType;
  description?: string;
  created_at: string;
}

export interface Ingredient {
  id: string;
  name_en: string;
  name_ar: string;
  unit: string;
  current_quantity: number;
  minimum_quantity: number;
  unit_cost: number;
  supplier?: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface InventoryMovement {
  id: string;
  ingredient_id: string;
  movement_type: InventoryMovementType;
  quantity: number;
  previous_quantity: number;
  new_quantity: number;
  unit_cost?: number;
  total_cost?: number;
  reference_type?: string;
  reference_id?: string;
  notes?: string;
  performed_by?: string;
  created_at: string;
}

export interface MenuItemIngredient {
  id: string;
  menu_item_id: string;
  ingredient_id: string;
  quantity_required: number;
  created_at: string;
}

export interface Role {
  id: string;
  name: string;
  display_name_en: string;
  display_name_ar: string;
  description?: string;
  permissions: string[];
  is_system: boolean;
  created_at: string;
  updated_at: string;
}

export interface AuditLog {
  id: string;
  user_id?: string;
  action: string;
  table_name: string;
  record_id?: string;
  old_values?: any;
  new_values?: any;
  ip_address?: string;
  user_agent?: string;
  created_at: string;
}

// View Types for Reports

export interface DailySalesSummary {
  sale_date: string;
  total_orders: number;
  unique_customers: number;
  total_revenue: number;
  average_order_value: number;
  paid_revenue: number;
  cancelled_orders: number;
}

export interface PopularMenuItem {
  id: string;
  name_en: string;
  name_ar: string;
  price: number;
  times_ordered: number;
  total_quantity_sold: number;
  total_revenue: number;
}

export interface CustomerLoyaltyRanking {
  id: string;
  full_name?: string;
  email: string;
  points_balance: number;
  total_points_earned: number;
  tier: LoyaltyTier;
  total_orders: number;
  total_spent: number;
}

