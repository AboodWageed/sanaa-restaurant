# توسيع قاعدة البيانات - نظام إدارة مطعم صنعاء

## 📊 نظرة عامة

تم توسيع قاعدة بيانات **Sana'a Restaurant Management System** لتشمل ميزات متقدمة تحول النظام من إدارة بسيطة إلى منصة متكاملة لإدارة المطاعم.

---

## 🆕 الجداول الجديدة المضافة

### 1. جدول الطاولات (tables)

يدير الطاولات الفعلية في المطعم ويربطها بنظام الحجوزات.

**الحقول:**

| الحقل | النوع | الوصف |
|------|------|-------|
| `id` | UUID | المعرف الفريد |
| `table_number` | Text | رقم الطاولة (فريد) |
| `capacity` | Integer | عدد الأشخاص |
| `location` | Text | الموقع (صالة رئيسية، شرفة، غرفة خاصة) |
| `status` | Enum | الحالة: متاحة، محجوزة، مشغولة، صيانة |
| `is_active` | Boolean | نشطة أم لا |
| `created_at` | Timestamp | تاريخ الإنشاء |
| `updated_at` | Timestamp | تاريخ التحديث |

**الاستخدام:**
- ربط الحجوزات بطاولات محددة
- تتبع حالة الطاولات في الوقت الفعلي
- إدارة سعة المطعم

---

### 2. جدول المدفوعات (payments)

تتبع تفصيلي لجميع المعاملات المالية منفصل عن الطلبات.

**الحقول:**

| الحقل | النوع | الوصف |
|------|------|-------|
| `id` | UUID | المعرف الفريد |
| `order_id` | UUID | مرجع للطلب |
| `amount` | Numeric | المبلغ |
| `payment_method` | Enum | طريقة الدفع (نقدي، بطاقة، أونلاين، محفظة) |
| `payment_status` | Enum | الحالة (معلق، مكتمل، فشل، مسترد) |
| `transaction_id` | Text | معرف المعاملة الخارجي |
| `gateway_response` | JSONB | استجابة بوابة الدفع الكاملة |
| `refund_amount` | Numeric | مبلغ الاسترداد |
| `refund_reason` | Text | سبب الاسترداد |
| `processed_by` | UUID | الموظف الذي عالج الدفع |
| `notes` | Text | ملاحظات |
| `created_at` | Timestamp | تاريخ الإنشاء |
| `updated_at` | Timestamp | تاريخ التحديث |

**الاستخدام:**
- تتبع دقيق للمدفوعات
- دعم الاسترداد والمبالغ المرتجعة
- تكامل مع بوابات الدفع الإلكتروني
- تقارير مالية مفصلة

---

### 3. نظام الولاء (loyalty_accounts & loyalty_transactions)

نظام متكامل لنقاط الولاء والمكافآت للعملاء.

#### جدول حسابات الولاء (loyalty_accounts)

| الحقل | النوع | الوصف |
|------|------|-------|
| `id` | UUID | المعرف الفريد |
| `user_id` | UUID | مرجع للعميل (فريد) |
| `points_balance` | Integer | رصيد النقاط الحالي |
| `total_points_earned` | Integer | إجمالي النقاط المكتسبة |
| `total_points_redeemed` | Integer | إجمالي النقاط المستردة |
| `tier` | Enum | المستوى (برونزي، فضي، ذهبي، بلاتيني) |
| `created_at` | Timestamp | تاريخ الإنشاء |
| `updated_at` | Timestamp | تاريخ التحديث |

#### جدول معاملات الولاء (loyalty_transactions)

| الحقل | النوع | الوصف |
|------|------|-------|
| `id` | UUID | المعرف الفريد |
| `loyalty_account_id` | UUID | مرجع لحساب الولاء |
| `order_id` | UUID | مرجع للطلب (اختياري) |
| `points` | Integer | النقاط (موجب للكسب، سالب للاسترداد) |
| `transaction_type` | Enum | النوع (مكتسب، مستخدم، منتهي، معدل) |
| `description` | Text | الوصف |
| `created_at` | Timestamp | تاريخ الإنشاء |

**الاستخدام:**
- مكافأة العملاء المنتظمين
- نظام مستويات (Tiers) تلقائي
- تتبع كامل لتاريخ النقاط
- حساب تلقائي للنقاط: 1 نقطة لكل 10 وحدات عملة

---

### 4. إدارة المخزون (ingredients, inventory_movements, menu_item_ingredients)

نظام متكامل لإدارة المكونات والمخزون.

#### جدول المكونات (ingredients)

| الحقل | النوع | الوصف |
|------|------|-------|
| `id` | UUID | المعرف الفريد |
| `name_en` | Text | الاسم بالإنجليزية |
| `name_ar` | Text | الاسم بالعربية |
| `unit` | Text | الوحدة (كجم، لتر، قطعة) |
| `current_quantity` | Numeric | الكمية الحالية |
| `minimum_quantity` | Numeric | الحد الأدنى (للتنبيه) |
| `unit_cost` | Numeric | تكلفة الوحدة |
| `supplier` | Text | المورد |
| `is_active` | Boolean | نشط أم لا |
| `created_at` | Timestamp | تاريخ الإنشاء |
| `updated_at` | Timestamp | تاريخ التحديث |

#### جدول حركة المخزون (inventory_movements)

| الحقل | النوع | الوصف |
|------|------|-------|
| `id` | UUID | المعرف الفريد |
| `ingredient_id` | UUID | مرجع للمكون |
| `movement_type` | Enum | النوع (دخول، خروج، تعديل، هدر) |
| `quantity` | Numeric | الكمية |
| `previous_quantity` | Numeric | الكمية السابقة |
| `new_quantity` | Numeric | الكمية الجديدة |
| `unit_cost` | Numeric | تكلفة الوحدة |
| `total_cost` | Numeric | التكلفة الإجمالية |
| `reference_type` | Text | نوع المرجع (طلب، شراء، يدوي) |
| `reference_id` | UUID | معرف المرجع |
| `notes` | Text | ملاحظات |
| `performed_by` | UUID | الموظف المنفذ |
| `created_at` | Timestamp | تاريخ الإنشاء |

#### جدول مكونات الأطباق (menu_item_ingredients)

| الحقل | النوع | الوصف |
|------|------|-------|
| `id` | UUID | المعرف الفريد |
| `menu_item_id` | UUID | مرجع للطبق |
| `ingredient_id` | UUID | مرجع للمكون |
| `quantity_required` | Numeric | الكمية المطلوبة لكل طبق |
| `created_at` | Timestamp | تاريخ الإنشاء |

**الاستخدام:**
- تتبع دقيق للمخزون
- تنبيهات تلقائية عند نقص المكونات
- ربط المكونات بالأطباق (الوصفات)
- حساب تكاليف الأطباق
- تقارير الهدر والاستهلاك

---

### 5. نظام الأدوار المتقدم (roles)

نظام صلاحيات متقدم قابل للتخصيص.

**الحقول:**

| الحقل | النوع | الوصف |
|------|------|-------|
| `id` | UUID | المعرف الفريد |
| `name` | Text | اسم الدور (فريد) |
| `display_name_en` | Text | الاسم المعروض بالإنجليزية |
| `display_name_ar` | Text | الاسم المعروض بالعربية |
| `description` | Text | الوصف |
| `permissions` | JSONB | مصفوفة الصلاحيات |
| `is_system` | Boolean | دور نظام (لا يمكن حذفه) |
| `created_at` | Timestamp | تاريخ الإنشاء |
| `updated_at` | Timestamp | تاريخ التحديث |

**الأدوار الافتراضية:**

1. **Super Admin (مدير النظام الرئيسي)**
   - صلاحيات كاملة: `["*"]`

2. **Admin (مدير)**
   - إدارة المستخدمين، القائمة، الطلبات، المخزون، التقارير

3. **Manager (مدير فرع)**
   - إدارة الطلبات، الحجوزات، عرض التقارير

4. **Staff (موظف)**
   - عرض الطلبات، تحديث حالة الطلبات، عرض القائمة

5. **Customer (عميل)**
   - تقديم طلبات، عرض القائمة، حجز طاولات

**الاستخدام:**
- تحكم دقيق في الصلاحيات
- إنشاء أدوار مخصصة
- فصل الوصول حسب المسؤوليات

---

### 6. سجلات التدقيق (audit_logs)

تتبع شامل لجميع العمليات في النظام.

**الحقول:**

| الحقل | النوع | الوصف |
|------|------|-------|
| `id` | UUID | المعرف الفريد |
| `user_id` | UUID | مرجع للمستخدم |
| `action` | Text | العملية (إنشاء، تحديث، حذف) |
| `table_name` | Text | اسم الجدول |
| `record_id` | UUID | معرف السجل |
| `old_values` | JSONB | القيم القديمة |
| `new_values` | JSONB | القيم الجديدة |
| `ip_address` | INET | عنوان IP |
| `user_agent` | Text | معلومات المتصفح |
| `created_at` | Timestamp | تاريخ الإنشاء |

**الاستخدام:**
- أمان وامتثال
- تتبع التغييرات
- استعادة البيانات
- تحليل الأنشطة

---

## 🔧 الدوال والمحفزات (Functions & Triggers)

### 1. تحديث تلقائي للتاريخ

```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

**يطبق على:**
- `tables`
- `payments`
- `loyalty_accounts`
- `ingredients`
- `roles`

### 2. فحص المخزون المنخفض

```sql
CREATE OR REPLACE FUNCTION check_low_inventory()
RETURNS TABLE (...)
```

**الوظيفة:**
- إرجاع قائمة بالمكونات التي انخفضت عن الحد الأدنى
- ترتيب حسب العجز

### 3. حساب نقاط الولاء

```sql
CREATE OR REPLACE FUNCTION calculate_loyalty_points(order_total numeric)
RETURNS integer
```

**القاعدة:**
- 1 نقطة لكل 10 وحدات عملة

---

## 📈 العروض (Views) للتقارير

### 1. ملخص المبيعات اليومية (daily_sales_summary)

```sql
CREATE OR REPLACE VIEW daily_sales_summary AS ...
```

**البيانات المتوفرة:**
- تاريخ البيع
- إجمالي الطلبات
- العملاء الفريدون
- إجمالي الإيرادات
- متوسط قيمة الطلب
- الإيرادات المدفوعة
- الطلبات الملغاة

### 2. الأطباق الأكثر شعبية (popular_menu_items)

```sql
CREATE OR REPLACE VIEW popular_menu_items AS ...
```

**البيانات المتوفرة:**
- معرف الطبق
- الاسم (عربي/إنجليزي)
- السعر
- عدد مرات الطلب
- الكمية الإجمالية المباعة
- الإيرادات الإجمالية

### 3. ترتيب ولاء العملاء (customer_loyalty_ranking)

```sql
CREATE OR REPLACE VIEW customer_loyalty_ranking AS ...
```

**البيانات المتوفرة:**
- معلومات العميل
- رصيد النقاط
- إجمالي النقاط المكتسبة
- المستوى
- إجمالي الطلبات
- إجمالي المبلغ المنفق

---

## 🔒 الأمان (Row Level Security)

تم تفعيل **RLS** على جميع الجداول الجديدة مع سياسات محددة:

### سياسات القراءة:
- **العملاء:** يمكنهم قراءة بياناتهم الخاصة فقط
- **الموظفون:** يمكنهم قراءة البيانات التشغيلية
- **المديرون:** وصول كامل للقراءة

### سياسات الكتابة:
- **العملاء:** يمكنهم إنشاء طلبات وحجوزات فقط
- **الموظفون:** يمكنهم تحديث حالات الطلبات
- **المديرون:** وصول كامل للكتابة

---

## 📊 الفهارس (Indexes)

تم إنشاء فهارس لتحسين الأداء:

```sql
-- Tables
CREATE INDEX idx_tables_status ON tables(status);
CREATE INDEX idx_tables_active ON tables(is_active);

-- Payments
CREATE INDEX idx_payments_order ON payments(order_id);
CREATE INDEX idx_payments_status ON payments(payment_status);
CREATE INDEX idx_payments_created ON payments(created_at DESC);

-- Loyalty
CREATE INDEX idx_loyalty_user ON loyalty_accounts(user_id);
CREATE INDEX idx_loyalty_transactions_account ON loyalty_transactions(loyalty_account_id);

-- Inventory
CREATE INDEX idx_ingredients_active ON ingredients(is_active);
CREATE INDEX idx_inventory_movements_ingredient ON inventory_movements(ingredient_id);
CREATE INDEX idx_inventory_movements_created ON inventory_movements(created_at DESC);

-- Audit
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_table ON audit_logs(table_name);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at DESC);
```

---

## 🚀 كيفية تطبيق الهجرة

### الخطوة 1: رفع الملف إلى Supabase

```bash
# باستخدام Supabase CLI
supabase db push

# أو يدويًا عبر لوحة التحكم
# Dashboard > SQL Editor > New Query > نسخ محتوى الملف وتشغيله
```

### الخطوة 2: التحقق من الجداول

```sql
-- التحقق من إنشاء الجداول
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN ('tables', 'payments', 'loyalty_accounts', 'ingredients', 'roles', 'audit_logs');
```

### الخطوة 3: التحقق من السياسات

```sql
-- التحقق من سياسات RLS
SELECT schemaname, tablename, policyname 
FROM pg_policies 
WHERE tablename IN ('tables', 'payments', 'loyalty_accounts');
```

---

## 📝 ملاحظات هامة

### 1. التوافق مع الإصدار السابق

جميع الجداول الجديدة **لا تؤثر** على الجداول الموجودة. النظام متوافق تمامًا مع الإصدار السابق.

### 2. البيانات الأولية

تم إدراج الأدوار الافتراضية تلقائيًا عند تطبيق الهجرة.

### 3. الأداء

- جميع الجداول مفهرسة بشكل صحيح
- العروض (Views) محسّنة للاستعلامات السريعة
- استخدام JSONB للبيانات المرنة

### 4. التوسع المستقبلي

البنية الحالية قابلة للتوسع بسهولة لإضافة:
- نظام الطلبات المسبقة
- التكامل مع خدمات التوصيل الخارجية
- نظام إدارة الموظفين المتقدم
- تحليلات ذكاء الأعمال (BI)

---

## 🔄 التحديثات المقترحة

### المرحلة التالية:

1. **نظام الإشعارات الفورية:**
   - استخدام Supabase Realtime
   - إشعارات للطلبات الجديدة
   - تنبيهات المخزون المنخفض

2. **تكامل بوابات الدفع:**
   - Stripe
   - PayPal
   - بوابات محلية

3. **نظام التقارير المتقدم:**
   - تقارير مخصصة
   - تصدير Excel/PDF
   - رسوم بيانية تفاعلية

4. **تطبيق الهاتف المحمول:**
   - React Native
   - تكامل مع نفس قاعدة البيانات

---

## ✅ الخلاصة

تم بنجاح توسيع قاعدة البيانات لتشمل:

✅ **7 جداول جديدة** لميزات متقدمة  
✅ **3 عروض (Views)** للتقارير  
✅ **3 دوال (Functions)** للعمليات الآلية  
✅ **محفزات (Triggers)** للتحديثات التلقائية  
✅ **سياسات أمان (RLS)** شاملة  
✅ **فهارس محسّنة** للأداء  
✅ **دعم ثنائي اللغة** (عربي/إنجليزي)  

النظام الآن جاهز لإدارة مطعم احترافي بجميع جوانبه التشغيلية والمالية والإدارية.

