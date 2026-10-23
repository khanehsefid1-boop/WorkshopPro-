# خلاصه اسکیمای Supabase (WorkshopPro)
آخرین بررسی: 2026-10-23، بعد از migration `0001_security_lockdown`.
این فایل جای `Docs/Schema.json` (۴۰۰ کیلوبایت) رو می‌گیره. فقط اینو بخون، مگه اینکه یه جدول خاص لازم باشه.

## قواعد امنیتی (تأییدشده)
- نقش کاربر: `user_profiles.role` ∈ admin، technician، warehouse_sales، customer.
- `is_staff()` همه‌ی دسترسی‌های کارکنان رو کنترل می‌کنه.
- تغییر نقش فقط توسط admin یا service role ممکنه (trigger `trg_prevent_role_change`).
- مشتری فقط ردیف‌های مربوط به `customer_id` خودش رو می‌بینه (policyهای `*_customer_select`).
- فرانت فقط از anon key استفاده می‌کنه. هیچ کلید service_role توی کد نیست.
- جدول بدون policy یعنی برای همه بسته‌ست. این عمدیه برای ماژول‌هایی که هنوز ساخته نشدن.

## گروه‌های جدول
- **مشتری و کاربر:** customers، customer_contacts، customer_locations، customer_user_memberships، customer_requests، customer_request_items، user_profiles، roles، permissions، role_permissions
- **دستگاه و تعمیر:** equipment، equipment_categories، equipment_fault_history، fault_codes، service_requests، service_request_photos، service_history، service_plans، warranties، contracts، diagnosis، jobs، job_status_history، job_needs، job_tests، job_tool_requirements، work_logs، controller_lab، controller_lab_components، controller_lab_tests
- **حمل و ارسال:** transport_requests، transport_quotes، dispatches، dispatch_tool_checklists، dispatch_tool_checklist_items، service_tool_requirements
- **فروش و مالی:** customer_quotations، quotation_items، invoices، invoice_items، payments، sales_returns، sales_return_items، pricing_rules، crm_activities، opportunities، expenses
- **خرید و تأمین:** suppliers، purchases، purchase_items، purchase_receipts، purchase_receipt_items، purchase_payments، purchase_cost_components، purchase_cost_allocations، sourcing_requests، supplier_quotes، market_prices
- **انبار و ابزار:** parts، stock_movements، stock_reservations، stock_transfers، stock_transfer_items، warehouses، warehouse_locations، inventory_counts، inventory_count_items، inventory_cost_layers، inventory_cost_layer_consumptions، inventory_cost_layer_consumption_reversals، inventory_cost_layer_consumption_reversal_cancellations، inventory_cost_adjustments، inventory_cost_consumption_adjustments، workshop_consumables، workshop_consumable_movements، tools، tool_items، tool_procurement_requests
- **دانش و سیستم:** documents، knowledge_documents، knowledge_chunks، schema_migrations

## وضعیت policy
- **دسترسی کارکنان (`*_staff_all` یا `is_staff()`):** بیشتر جدول‌های بالا، از جمله invoices، payments، jobs، customers، service_requests، expenses.
- **دسترسی مشتری (SELECT یا INSERT):** customers، customer_quotations، quotation_items، payments، invoices، invoice_items، equipment، service_requests، customer_requests، jobs، user_profiles (فقط ردیف خودش).
- **بسته (RLS فعال، بدون policy):** مال ماژول‌های FIFO، هزینه‌یابی، دستیار هوشمند، کرایه و لابراتوار که هنوز ساخته نشدن. هر وقت ساخته شدن، policy اضافه کن.

## باز
- صفحه‌ی مالی مشتری ساخته نشده. وقتی ساخته شد، دسترسی `invoices_customer_select` دوباره تست بشه.
- فایل rollback مربوط به policyهای قبل از migration ذخیره نشده.
- پوشه‌ی `Docs` با D بزرگ باید به `docs` تغییر نام پیدا کنه.
