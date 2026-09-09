# راه‌اندازی ورود مشتری با موبایل + OTP (کاوه‌نگار)

## ۱. ساخت الگوی اعتبارسنجی در کاوه‌نگار

1. وارد پنل kavenegar.com شو (اگه عضو نیستی، ثبت‌نام کن — فقط موبایل کافیه).
2. برو به منوی **اعتبار سنجی → تعریف الگوی اعتبار سنجی**.
3. یه اسم انگلیسی بدون فاصله و بدون نقطه بده، مثلاً: `WorkshopProLogin`
4. تو متن الگو حتماً `%token` باید باشه، مثلاً:
   ```
   کد ورود شما به WorkshopPro: %token
   ```
5. ذخیره کن و منتظر تایید کاوه‌نگار بمون (معمولاً سریع).
6. برو به بخش **حساب من** و **API-Key** رو کپی کن.
7. حساب رو با مبلغ دلخواه شارژ کن (سرویس Verify هزینه‌ی هر پیامک رو از اعتبار حساب کم می‌کنه).

## ۲. تنظیم Supabase Auth برای ورود با موبایل

تو Dashboard پروژه‌ی Supabase:

1. **Authentication → Providers → Phone** رو فعال کن.
2. **Authentication → Hooks → Send SMS hook** رو فعال کن، نوع هوک رو
   روی **HTTPS** بذار و آدرس Edge Function رو بده (بعد از دیپلوی مرحله‌ی بعد).
3. Supabase یه Secret به فرم `v1,whsec_...` می‌ده — کپیش کن.

## ۳. دیپلوی Edge Function

```bash
supabase login
supabase link --project-ref tbsxccpkpklmvstyqwfk
supabase secrets set KAVENEGAR_API_KEY=xxxxxxxxxxxx
supabase secrets set KAVENEGAR_TEMPLATE=WorkshopProLogin
supabase secrets set SEND_SMS_HOOK_SECRET=v1,whsec_xxxx
supabase functions deploy send-sms-hook --no-verify-jwt
```

## ۴. Policy های امنیتی لازم (RLS)

چون مشتری خودش (بدون دخالت مدیر) یه رکورد customers و user_profiles می‌سازه،
باید این Policy ها رو اضافه کنی (این‌ها هنوز تو schema اصلی نبودن):

```sql
alter table public.customers enable row level security;
alter table public.user_profiles enable row level security;

create policy "customers_self_signup_insert"
on public.customers for insert
to authenticated
with check (true);

create policy "user_profiles_self_select"
on public.user_profiles for select
to authenticated
using (id = auth.uid());

create policy "user_profiles_self_upsert"
on public.user_profiles for insert
to authenticated
with check (id = auth.uid());

create policy "user_profiles_self_update"
on public.user_profiles for update
to authenticated
using (id = auth.uid());

create policy "customers_self_select"
on public.customers for select
to authenticated
using (
  id in (select customer_id from public.user_profiles where id = auth.uid())
  or exists (select 1 from public.user_profiles where id = auth.uid() and role in ('admin','technician','warehouse_sales'))
);
```

**مهم:** این فقط شروع کاره. برای هر جدول دیگه‌ای که مشتری قراره ببینه
(مثل jobs, service_requests, invoices, equipment) باید Policy مشابه بسازیم
که فقط ردیف‌های مرتبط با customer_id خودش رو ببینه. این کار رو تو قدم بعدی
(پنل مدیر + دسترسی‌ها) کامل می‌کنیم.

## ۵. تست

1. customer-auth.html رو باز کن (لینک گیت‌هاب پیجزت).
2. شماره موبایل بزن → باید کد OTP با پیامک بیاد.
3. کد رو وارد کن → برای کاربر جدید فرم «نام شرکت» میاد → بعد از ثبت،
   ریدایرکت می‌شه به customer-dashboard.html (این صفحه رو قدم بعدی می‌سازیم).

---

اگه هنگام تست به خطا خوردی، پیام دقیق خطا (از console مرورگر یا از پاسخ
کاوه‌نگار) رو برام بفرست تا دقیق‌تر عیب‌یابی کنم.
