/*
  # Advanced Features Migration for Sana'a Restaurant
  
  ## Overview
  This migration adds advanced features to the restaurant management system:
  - Tables management for reservations
  - Separate payments tracking
  - Loyalty points system
  - Inventory management (ingredients and movements)
  - Advanced roles and permissions
  - Audit logs for tracking changes
  
  ## New Tables
  
  ### 1. Tables
  - Physical tables in the restaurant for reservation management
  
  ### 2. Payments
  - Detailed payment transaction records
  
  ### 3. Loyalty Accounts
  - Customer loyalty points and rewards tracking
  
  ### 4. Ingredients
  - Raw materials and ingredients inventory
  
  ### 5. Inventory Movements
  - Track all inventory changes (in/out/adjustment)
  
  ### 6. Roles
  - Advanced role-based access control
  
  ### 7. Audit Logs
  - System-wide activity tracking for security and compliance
*/

-- ============================================
-- Tables Management
-- ============================================

CREATE TABLE IF NOT EXISTS tables (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  table_number text UNIQUE NOT NULL,
  capacity integer NOT NULL CHECK (capacity > 0),
  location text, -- e.g., 'Main Hall', 'Terrace', 'Private Room'
  status text DEFAULT 'available' CHECK (status IN ('available', 'occupied', 'reserved', 'maintenance')),
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Add table_id to reservations
ALTER TABLE reservations 
ADD COLUMN IF NOT EXISTS table_id uuid REFERENCES tables(id) ON DELETE SET NULL;

-- Indexes for tables
CREATE INDEX IF NOT EXISTS idx_tables_status ON tables(status);
CREATE INDEX IF NOT EXISTS idx_tables_active ON tables(is_active);

-- RLS for tables
ALTER TABLE tables ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read active tables"
  ON tables FOR SELECT
  TO public
  USING (is_active = true);

CREATE POLICY "Admin can manage tables"
  ON tables FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role IN ('admin', 'staff')
    )
  );

-- ============================================
-- Payments Management
-- ============================================

CREATE TABLE IF NOT EXISTS payments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid REFERENCES orders(id) ON DELETE CASCADE,
  amount numeric(10,2) NOT NULL CHECK (amount >= 0),
  payment_method text NOT NULL CHECK (payment_method IN ('cash', 'card', 'online', 'wallet')),
  payment_status text DEFAULT 'pending' CHECK (payment_status IN ('pending', 'completed', 'failed', 'refunded')),
  transaction_id text, -- External payment gateway transaction ID
  gateway_response jsonb, -- Store full gateway response
  refund_amount numeric(10,2) DEFAULT 0,
  refund_reason text,
  processed_by uuid REFERENCES users(id), -- Staff who processed the payment
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Indexes for payments
CREATE INDEX IF NOT EXISTS idx_payments_order ON payments(order_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(payment_status);
CREATE INDEX IF NOT EXISTS idx_payments_created ON payments(created_at DESC);

-- RLS for payments
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own payments"
  ON payments FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = payments.order_id AND orders.user_id = auth.uid()
    )
  );

CREATE POLICY "Admin can manage all payments"
  ON payments FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role IN ('admin', 'staff')
    )
  );

-- ============================================
-- Loyalty System
-- ============================================

CREATE TABLE IF NOT EXISTS loyalty_accounts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid UNIQUE REFERENCES users(id) ON DELETE CASCADE,
  points_balance integer DEFAULT 0 CHECK (points_balance >= 0),
  total_points_earned integer DEFAULT 0,
  total_points_redeemed integer DEFAULT 0,
  tier text DEFAULT 'bronze' CHECK (tier IN ('bronze', 'silver', 'gold', 'platinum')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS loyalty_transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loyalty_account_id uuid REFERENCES loyalty_accounts(id) ON DELETE CASCADE,
  order_id uuid REFERENCES orders(id) ON DELETE SET NULL,
  points integer NOT NULL, -- Positive for earning, negative for redemption
  transaction_type text NOT NULL CHECK (transaction_type IN ('earned', 'redeemed', 'expired', 'adjusted')),
  description text,
  created_at timestamptz DEFAULT now()
);

-- Indexes for loyalty
CREATE INDEX IF NOT EXISTS idx_loyalty_user ON loyalty_accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_loyalty_transactions_account ON loyalty_transactions(loyalty_account_id);

-- RLS for loyalty
ALTER TABLE loyalty_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE loyalty_transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own loyalty account"
  ON loyalty_accounts FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Users can read own loyalty transactions"
  ON loyalty_transactions FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM loyalty_accounts
      WHERE loyalty_accounts.id = loyalty_transactions.loyalty_account_id 
      AND loyalty_accounts.user_id = auth.uid()
    )
  );

CREATE POLICY "Admin can manage loyalty"
  ON loyalty_accounts FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

CREATE POLICY "Admin can manage loyalty transactions"
  ON loyalty_transactions FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

-- ============================================
-- Inventory Management
-- ============================================

CREATE TABLE IF NOT EXISTS ingredients (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name_en text NOT NULL,
  name_ar text NOT NULL,
  unit text NOT NULL, -- e.g., 'kg', 'liter', 'piece'
  current_quantity numeric(10,2) DEFAULT 0 CHECK (current_quantity >= 0),
  minimum_quantity numeric(10,2) DEFAULT 0, -- Alert threshold
  unit_cost numeric(10,2) DEFAULT 0,
  supplier text,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS inventory_movements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ingredient_id uuid REFERENCES ingredients(id) ON DELETE CASCADE,
  movement_type text NOT NULL CHECK (movement_type IN ('in', 'out', 'adjustment', 'waste')),
  quantity numeric(10,2) NOT NULL,
  previous_quantity numeric(10,2) NOT NULL,
  new_quantity numeric(10,2) NOT NULL,
  unit_cost numeric(10,2),
  total_cost numeric(10,2),
  reference_type text, -- e.g., 'order', 'purchase', 'manual'
  reference_id uuid, -- ID of related order or purchase
  notes text,
  performed_by uuid REFERENCES users(id),
  created_at timestamptz DEFAULT now()
);

-- Link ingredients to menu items
CREATE TABLE IF NOT EXISTS menu_item_ingredients (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  menu_item_id uuid REFERENCES menu_items(id) ON DELETE CASCADE,
  ingredient_id uuid REFERENCES ingredients(id) ON DELETE CASCADE,
  quantity_required numeric(10,2) NOT NULL, -- Amount needed per menu item
  created_at timestamptz DEFAULT now(),
  UNIQUE(menu_item_id, ingredient_id)
);

-- Indexes for inventory
CREATE INDEX IF NOT EXISTS idx_ingredients_active ON ingredients(is_active);
CREATE INDEX IF NOT EXISTS idx_inventory_movements_ingredient ON inventory_movements(ingredient_id);
CREATE INDEX IF NOT EXISTS idx_inventory_movements_created ON inventory_movements(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_menu_item_ingredients_menu ON menu_item_ingredients(menu_item_id);

-- RLS for inventory
ALTER TABLE ingredients ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_item_ingredients ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read active ingredients"
  ON ingredients FOR SELECT
  TO public
  USING (is_active = true);

CREATE POLICY "Admin can manage ingredients"
  ON ingredients FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role IN ('admin', 'staff')
    )
  );

CREATE POLICY "Admin can read inventory movements"
  ON inventory_movements FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role IN ('admin', 'staff')
    )
  );

CREATE POLICY "Admin can create inventory movements"
  ON inventory_movements FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role IN ('admin', 'staff')
    )
  );

CREATE POLICY "Anyone can read menu item ingredients"
  ON menu_item_ingredients FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Admin can manage menu item ingredients"
  ON menu_item_ingredients FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

-- ============================================
-- Advanced Roles and Permissions
-- ============================================

CREATE TABLE IF NOT EXISTS roles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  display_name_en text NOT NULL,
  display_name_ar text NOT NULL,
  description text,
  permissions jsonb DEFAULT '[]'::jsonb, -- Array of permission strings
  is_system boolean DEFAULT false, -- System roles cannot be deleted
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Insert default roles
INSERT INTO roles (name, display_name_en, display_name_ar, description, is_system, permissions) VALUES
  ('super_admin', 'Super Administrator', 'مدير النظام الرئيسي', 'Full system access', true, '["*"]'::jsonb),
  ('admin', 'Administrator', 'مدير', 'Full restaurant management access', true, '["manage_users", "manage_menu", "manage_orders", "manage_inventory", "view_reports"]'::jsonb),
  ('manager', 'Manager', 'مدير فرع', 'Restaurant operations management', true, '["manage_orders", "manage_reservations", "view_reports"]'::jsonb),
  ('staff', 'Staff', 'موظف', 'Basic operational access', true, '["view_orders", "update_order_status", "view_menu"]'::jsonb),
  ('customer', 'Customer', 'عميل', 'Customer access', true, '["place_order", "view_menu", "make_reservation"]'::jsonb)
ON CONFLICT (name) DO NOTHING;

-- RLS for roles
ALTER TABLE roles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read roles"
  ON roles FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Admin can manage roles"
  ON roles FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

-- ============================================
-- Audit Logs
-- ============================================

CREATE TABLE IF NOT EXISTS audit_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE SET NULL,
  action text NOT NULL, -- e.g., 'create', 'update', 'delete'
  table_name text NOT NULL,
  record_id uuid,
  old_values jsonb,
  new_values jsonb,
  ip_address inet,
  user_agent text,
  created_at timestamptz DEFAULT now()
);

-- Indexes for audit logs
CREATE INDEX IF NOT EXISTS idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_table ON audit_logs(table_name);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created ON audit_logs(created_at DESC);

-- RLS for audit logs
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin can read audit logs"
  ON audit_logs FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role = 'admin'
    )
  );

CREATE POLICY "System can insert audit logs"
  ON audit_logs FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- ============================================
-- Functions and Triggers
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply update trigger to tables with updated_at
CREATE TRIGGER update_tables_updated_at BEFORE UPDATE ON tables
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_loyalty_accounts_updated_at BEFORE UPDATE ON loyalty_accounts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_ingredients_updated_at BEFORE UPDATE ON ingredients
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_roles_updated_at BEFORE UPDATE ON roles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to check low inventory
CREATE OR REPLACE FUNCTION check_low_inventory()
RETURNS TABLE (
  ingredient_id uuid,
  ingredient_name_en text,
  ingredient_name_ar text,
  current_quantity numeric,
  minimum_quantity numeric,
  deficit numeric
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    i.id,
    i.name_en,
    i.name_ar,
    i.current_quantity,
    i.minimum_quantity,
    (i.minimum_quantity - i.current_quantity) as deficit
  FROM ingredients i
  WHERE i.current_quantity < i.minimum_quantity
    AND i.is_active = true
  ORDER BY (i.minimum_quantity - i.current_quantity) DESC;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate loyalty points for an order
CREATE OR REPLACE FUNCTION calculate_loyalty_points(order_total numeric)
RETURNS integer AS $$
BEGIN
  -- 1 point for every 10 currency units spent
  RETURN FLOOR(order_total / 10)::integer;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- Views for Reporting
-- ============================================

-- Daily sales summary view
CREATE OR REPLACE VIEW daily_sales_summary AS
SELECT 
  DATE(o.created_at) as sale_date,
  COUNT(DISTINCT o.id) as total_orders,
  COUNT(DISTINCT o.user_id) as unique_customers,
  SUM(o.total_amount) as total_revenue,
  AVG(o.total_amount) as average_order_value,
  SUM(CASE WHEN o.payment_status = 'paid' THEN o.total_amount ELSE 0 END) as paid_revenue,
  SUM(CASE WHEN o.status = 'cancelled' THEN 1 ELSE 0 END) as cancelled_orders
FROM orders o
GROUP BY DATE(o.created_at)
ORDER BY sale_date DESC;

-- Popular menu items view
CREATE OR REPLACE VIEW popular_menu_items AS
SELECT 
  mi.id,
  mi.name_en,
  mi.name_ar,
  mi.price,
  COUNT(oi.id) as times_ordered,
  SUM(oi.quantity) as total_quantity_sold,
  SUM(oi.subtotal) as total_revenue
FROM menu_items mi
LEFT JOIN order_items oi ON mi.id = oi.menu_item_id
LEFT JOIN orders o ON oi.order_id = o.id
WHERE o.status != 'cancelled'
GROUP BY mi.id, mi.name_en, mi.name_ar, mi.price
ORDER BY total_quantity_sold DESC;

-- Customer loyalty ranking view
CREATE OR REPLACE VIEW customer_loyalty_ranking AS
SELECT 
  u.id,
  u.full_name,
  u.email,
  la.points_balance,
  la.total_points_earned,
  la.tier,
  COUNT(DISTINCT o.id) as total_orders,
  SUM(o.total_amount) as total_spent
FROM users u
LEFT JOIN loyalty_accounts la ON u.id = la.user_id
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.role = 'customer'
GROUP BY u.id, u.full_name, u.email, la.points_balance, la.total_points_earned, la.tier
ORDER BY la.total_points_earned DESC;

-- Comments
COMMENT ON TABLE tables IS 'Physical tables in the restaurant for reservation management';
COMMENT ON TABLE payments IS 'Detailed payment transaction records separate from orders';
COMMENT ON TABLE loyalty_accounts IS 'Customer loyalty points and tier information';
COMMENT ON TABLE loyalty_transactions IS 'History of all loyalty point transactions';
COMMENT ON TABLE ingredients IS 'Raw materials and ingredients inventory';
COMMENT ON TABLE inventory_movements IS 'Track all inventory changes for auditing';
COMMENT ON TABLE menu_item_ingredients IS 'Recipe: ingredients required for each menu item';
COMMENT ON TABLE roles IS 'Advanced role-based access control system';
COMMENT ON TABLE audit_logs IS 'System-wide activity tracking for security and compliance';

