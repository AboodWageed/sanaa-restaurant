/*
  # Sana'a Restaurant Complete Database Schema

  ## Overview
  This migration creates the complete database structure for Sana'a Restaurant management system,
  including customer-facing features and admin management capabilities.

  ## Tables Created

  ### 1. Users
  - `id` (uuid, primary key) - Unique user identifier linked to auth.users
  - `email` (text, unique, not null) - User email address
  - `full_name` (text) - User's full name
  - `phone` (text) - Contact phone number
  - `address` (text) - Delivery address
  - `role` (text) - User role: 'customer', 'admin', 'staff'
  - `created_at` (timestamptz) - Account creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### 2. Staff
  - `id` (uuid, primary key) - Staff member identifier
  - `user_id` (uuid, foreign key) - Reference to users table
  - `position` (text) - Job position/title
  - `hire_date` (date) - Date of hiring
  - `salary` (numeric) - Monthly salary
  - `status` (text) - Employment status: 'active', 'inactive'
  - `created_at` (timestamptz) - Record creation timestamp

  ### 3. Categories
  - `id` (uuid, primary key) - Category identifier
  - `name_en` (text) - Category name in English
  - `name_ar` (text) - Category name in Arabic
  - `description_en` (text) - Description in English
  - `description_ar` (text) - Description in Arabic
  - `image_url` (text) - Category image
  - `display_order` (integer) - Sort order for display
  - `is_active` (boolean) - Visibility status
  - `created_at` (timestamptz) - Creation timestamp

  ### 4. MenuItems
  - `id` (uuid, primary key) - Menu item identifier
  - `category_id` (uuid, foreign key) - Reference to categories
  - `name_en` (text) - Item name in English
  - `name_ar` (text) - Item name in Arabic
  - `description_en` (text) - Description in English
  - `description_ar` (text) - Description in Arabic
  - `price` (numeric) - Item price
  - `image_url` (text) - Item image
  - `is_available` (boolean) - Availability status
  - `is_featured` (boolean) - Featured item flag
  - `preparation_time` (integer) - Time in minutes
  - `calories` (integer) - Nutritional information
  - `created_at` (timestamptz) - Creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### 5. Orders
  - `id` (uuid, primary key) - Order identifier
  - `user_id` (uuid, foreign key) - Reference to users
  - `order_number` (text, unique) - Human-readable order number
  - `total_amount` (numeric) - Total order cost
  - `status` (text) - Order status: 'pending', 'confirmed', 'preparing', 'ready', 'delivered', 'cancelled'
  - `payment_method` (text) - Payment method: 'cash', 'card', 'online'
  - `payment_status` (text) - Payment status: 'pending', 'paid', 'refunded'
  - `delivery_address` (text) - Delivery location
  - `delivery_fee` (numeric) - Delivery charge
  - `notes` (text) - Special instructions
  - `created_at` (timestamptz) - Order placement time
  - `updated_at` (timestamptz) - Last update time

  ### 6. OrderItems
  - `id` (uuid, primary key) - Order item identifier
  - `order_id` (uuid, foreign key) - Reference to orders
  - `menu_item_id` (uuid, foreign key) - Reference to menu_items
  - `quantity` (integer) - Number of items
  - `unit_price` (numeric) - Price per unit at order time
  - `subtotal` (numeric) - Calculated subtotal
  - `notes` (text) - Item-specific notes

  ### 7. OrderTracking
  - `id` (uuid, primary key) - Tracking entry identifier
  - `order_id` (uuid, foreign key) - Reference to orders
  - `status` (text) - Status at this point
  - `notes` (text) - Status update notes
  - `created_at` (timestamptz) - Status change timestamp

  ### 8. Reservations
  - `id` (uuid, primary key) - Reservation identifier
  - `user_id` (uuid, foreign key) - Reference to users
  - `reservation_date` (date) - Date of reservation
  - `reservation_time` (time) - Time of reservation
  - `party_size` (integer) - Number of guests
  - `status` (text) - Status: 'pending', 'confirmed', 'cancelled', 'completed'
  - `special_requests` (text) - Special requirements
  - `created_at` (timestamptz) - Booking timestamp

  ### 9. Reviews
  - `id` (uuid, primary key) - Review identifier
  - `user_id` (uuid, foreign key) - Reference to users
  - `order_id` (uuid, foreign key) - Reference to orders (optional)
  - `rating` (integer) - Rating 1-5
  - `comment` (text) - Review text
  - `is_approved` (boolean) - Moderation status
  - `created_at` (timestamptz) - Review submission time

  ### 10. Notifications
  - `id` (uuid, primary key) - Notification identifier
  - `user_id` (uuid, foreign key) - Reference to users
  - `title` (text) - Notification title
  - `message` (text) - Notification content
  - `type` (text) - Type: 'order', 'reservation', 'promotion', 'system'
  - `is_read` (boolean) - Read status
  - `created_at` (timestamptz) - Creation timestamp

  ### 11. BlogPosts
  - `id` (uuid, primary key) - Blog post identifier
  - `author_id` (uuid, foreign key) - Reference to users
  - `title_en` (text) - Title in English
  - `title_ar` (text) - Title in Arabic
  - `content_en` (text) - Content in English
  - `content_ar` (text) - Content in Arabic
  - `image_url` (text) - Featured image
  - `is_published` (boolean) - Publication status
  - `published_at` (timestamptz) - Publication timestamp
  - `created_at` (timestamptz) - Creation timestamp

  ### 12. Gallery
  - `id` (uuid, primary key) - Gallery item identifier
  - `title_en` (text) - Image title in English
  - `title_ar` (text) - Image title in Arabic
  - `image_url` (text) - Image URL
  - `description_en` (text) - Description in English
  - `description_ar` (text) - Description in Arabic
  - `display_order` (integer) - Sort order
  - `is_active` (boolean) - Visibility status
  - `created_at` (timestamptz) - Upload timestamp

  ### 13. Offers
  - `id` (uuid, primary key) - Offer identifier
  - `title_en` (text) - Offer title in English
  - `title_ar` (text) - Offer title in Arabic
  - `description_en` (text) - Description in English
  - `description_ar` (text) - Description in Arabic
  - `discount_percentage` (numeric) - Discount amount
  - `image_url` (text) - Offer image
  - `start_date` (date) - Offer start date
  - `end_date` (date) - Offer end date
  - `is_active` (boolean) - Active status
  - `created_at` (timestamptz) - Creation timestamp

  ### 14. Coupons
  - `id` (uuid, primary key) - Coupon identifier
  - `code` (text, unique) - Coupon code
  - `discount_type` (text) - Type: 'percentage', 'fixed'
  - `discount_value` (numeric) - Discount amount
  - `min_order_amount` (numeric) - Minimum order requirement
  - `max_uses` (integer) - Usage limit
  - `used_count` (integer) - Times used
  - `start_date` (date) - Valid from date
  - `end_date` (date) - Valid until date
  - `is_active` (boolean) - Active status
  - `created_at` (timestamptz) - Creation timestamp

  ### 15. Settings
  - `id` (uuid, primary key) - Setting identifier
  - `key` (text, unique) - Setting key
  - `value` (text) - Setting value
  - `description` (text) - Setting description
  - `updated_at` (timestamptz) - Last update timestamp

  ### 16. ContactMessages
  - `id` (uuid, primary key) - Message identifier
  - `name` (text) - Sender name
  - `email` (text) - Sender email
  - `phone` (text) - Sender phone
  - `subject` (text) - Message subject
  - `message` (text) - Message content
  - `is_read` (boolean) - Read status
  - `created_at` (timestamptz) - Submission timestamp

  ## Security
  - Row Level Security (RLS) enabled on all tables
  - Policies created for authenticated users, admin, and public access
  - Users can only access their own data
  - Admin users have full access to all data
  - Public users can read menu, categories, offers, and gallery

  ## Important Notes
  1. All tables use UUID primary keys with gen_random_uuid()
  2. Timestamps use timestamptz with default now()
  3. Bilingual support (English/Arabic) for content
  4. Comprehensive status tracking for orders and reservations
  5. Moderation capabilities for reviews and blog posts
*/

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  full_name text,
  phone text,
  address text,
  role text DEFAULT 'customer' CHECK (role IN ('customer', 'admin', 'staff')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own data"
  ON users FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own data"
  ON users FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Anyone can insert user data"
  ON users FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Staff table
CREATE TABLE IF NOT EXISTS staff (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  position text,
  hire_date date,
  salary numeric(10,2),
  status text DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
  created_at timestamptz DEFAULT now()
);

ALTER TABLE staff ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin can manage staff"
  ON staff FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name_en text NOT NULL,
  name_ar text NOT NULL,
  description_en text,
  description_ar text,
  image_url text,
  display_order integer DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read active categories"
  ON categories FOR SELECT
  TO public
  USING (is_active = true);

CREATE POLICY "Admin can manage categories"
  ON categories FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

-- MenuItems table
CREATE TABLE IF NOT EXISTS menu_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id uuid REFERENCES categories(id) ON DELETE CASCADE,
  name_en text NOT NULL,
  name_ar text NOT NULL,
  description_en text,
  description_ar text,
  price numeric(10,2) NOT NULL,
  image_url text,
  is_available boolean DEFAULT true,
  is_featured boolean DEFAULT false,
  preparation_time integer DEFAULT 15,
  calories integer,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read available menu items"
  ON menu_items FOR SELECT
  TO public
  USING (is_available = true);

CREATE POLICY "Admin can manage menu items"
  ON menu_items FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE SET NULL,
  order_number text UNIQUE NOT NULL,
  total_amount numeric(10,2) NOT NULL,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'preparing', 'ready', 'delivered', 'cancelled')),
  payment_method text CHECK (payment_method IN ('cash', 'card', 'online')),
  payment_status text DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'refunded')),
  delivery_address text,
  delivery_fee numeric(10,2) DEFAULT 0,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own orders"
  ON orders FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create orders"
  ON orders FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admin can manage all orders"
  ON orders FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role IN ('admin', 'staff')
    )
  );

-- OrderItems table
CREATE TABLE IF NOT EXISTS order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid REFERENCES orders(id) ON DELETE CASCADE,
  menu_item_id uuid REFERENCES menu_items(id) ON DELETE SET NULL,
  quantity integer NOT NULL DEFAULT 1,
  unit_price numeric(10,2) NOT NULL,
  subtotal numeric(10,2) NOT NULL,
  notes text
);

ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own order items"
  ON order_items FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can create order items"
  ON order_items FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid()
    )
  );

CREATE POLICY "Admin can manage all order items"
  ON order_items FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role IN ('admin', 'staff')
    )
  );

-- OrderTracking table
CREATE TABLE IF NOT EXISTS order_tracking (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid REFERENCES orders(id) ON DELETE CASCADE,
  status text NOT NULL,
  notes text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE order_tracking ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own order tracking"
  ON order_tracking FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_tracking.order_id AND orders.user_id = auth.uid()
    )
  );

CREATE POLICY "Staff can manage order tracking"
  ON order_tracking FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role IN ('admin', 'staff')
    )
  );

-- Reservations table
CREATE TABLE IF NOT EXISTS reservations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  reservation_date date NOT NULL,
  reservation_time time NOT NULL,
  party_size integer NOT NULL,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
  special_requests text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own reservations"
  ON reservations FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create reservations"
  ON reservations FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own reservations"
  ON reservations FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admin can manage all reservations"
  ON reservations FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role IN ('admin', 'staff')
    )
  );

-- Reviews table
CREATE TABLE IF NOT EXISTS reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  order_id uuid REFERENCES orders(id) ON DELETE SET NULL,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment text,
  is_approved boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read approved reviews"
  ON reviews FOR SELECT
  TO public
  USING (is_approved = true);

CREATE POLICY "Users can create reviews"
  ON reviews FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can read own reviews"
  ON reviews FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Admin can manage reviews"
  ON reviews FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  title text NOT NULL,
  message text NOT NULL,
  type text CHECK (type IN ('order', 'reservation', 'promotion', 'system')),
  is_read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own notifications"
  ON notifications FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications"
  ON notifications FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admin can create notifications"
  ON notifications FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

-- BlogPosts table
CREATE TABLE IF NOT EXISTS blog_posts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id uuid REFERENCES users(id) ON DELETE SET NULL,
  title_en text NOT NULL,
  title_ar text NOT NULL,
  content_en text NOT NULL,
  content_ar text NOT NULL,
  image_url text,
  is_published boolean DEFAULT false,
  published_at timestamptz,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE blog_posts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read published blog posts"
  ON blog_posts FOR SELECT
  TO public
  USING (is_published = true);

CREATE POLICY "Admin can manage blog posts"
  ON blog_posts FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

-- Gallery table
CREATE TABLE IF NOT EXISTS gallery (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title_en text,
  title_ar text,
  image_url text NOT NULL,
  description_en text,
  description_ar text,
  display_order integer DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE gallery ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read active gallery items"
  ON gallery FOR SELECT
  TO public
  USING (is_active = true);

CREATE POLICY "Admin can manage gallery"
  ON gallery FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

-- Offers table
CREATE TABLE IF NOT EXISTS offers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title_en text NOT NULL,
  title_ar text NOT NULL,
  description_en text,
  description_ar text,
  discount_percentage numeric(5,2),
  image_url text,
  start_date date NOT NULL,
  end_date date NOT NULL,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE offers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read active offers"
  ON offers FOR SELECT
  TO public
  USING (is_active = true AND CURRENT_DATE BETWEEN start_date AND end_date);

CREATE POLICY "Admin can manage offers"
  ON offers FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

-- Coupons table
CREATE TABLE IF NOT EXISTS coupons (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  discount_type text CHECK (discount_type IN ('percentage', 'fixed')),
  discount_value numeric(10,2) NOT NULL,
  min_order_amount numeric(10,2) DEFAULT 0,
  max_uses integer,
  used_count integer DEFAULT 0,
  start_date date NOT NULL,
  end_date date NOT NULL,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read active coupons"
  ON coupons FOR SELECT
  TO authenticated
  USING (is_active = true AND CURRENT_DATE BETWEEN start_date AND end_date);

CREATE POLICY "Admin can manage coupons"
  ON coupons FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

-- Settings table
CREATE TABLE IF NOT EXISTS settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key text UNIQUE NOT NULL,
  value text,
  description text,
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read settings"
  ON settings FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Admin can manage settings"
  ON settings FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

-- ContactMessages table
CREATE TABLE IF NOT EXISTS contact_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  phone text,
  subject text NOT NULL,
  message text NOT NULL,
  is_read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can create contact messages"
  ON contact_messages FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Admin can read contact messages"
  ON contact_messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

CREATE POLICY "Admin can update contact messages"
  ON contact_messages FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_menu_items_category ON menu_items(category_id);
CREATE INDEX IF NOT EXISTS idx_orders_user ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_tracking_order ON order_tracking(order_id);
CREATE INDEX IF NOT EXISTS idx_reservations_user ON reservations(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_user ON reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_blog_posts_author ON blog_posts(author_id);

-- Insert default settings
INSERT INTO settings (key, value, description) VALUES
  ('restaurant_name_en', 'Sana''a Restaurant', 'Restaurant name in English'),
  ('restaurant_name_ar', 'مطعم صنعاء', 'Restaurant name in Arabic'),
  ('restaurant_phone', '+967 XXX XXX XXX', 'Restaurant contact phone'),
  ('restaurant_email', 'info@sanaarestaurant.com', 'Restaurant contact email'),
  ('restaurant_address_en', 'Sana''a, Yemen', 'Restaurant address in English'),
  ('restaurant_address_ar', 'صنعاء، اليمن', 'Restaurant address in Arabic'),
  ('delivery_fee', '5', 'Default delivery fee'),
  ('min_order_amount', '10', 'Minimum order amount'),
  ('currency', 'YER', 'Currency code')
ON CONFLICT (key) DO NOTHING;