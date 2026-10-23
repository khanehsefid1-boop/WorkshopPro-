begin;

-- تشخیص کاربر کارمند، بدون وابستگی به policyهای user_profiles
create or replace function public.is_staff()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.user_profiles
    where id = auth.uid()
      and role in ('admin', 'technician', 'warehouse_sales')
  );
$$;

-- فعال‌سازی RLS روی جدول‌هایی که باز مانده بودند
alter table public.job_needs enable row level security;
alter table public.workshop_consumables enable row level security;
alter table public.workshop_consumable_movements enable row level security;
alter table public.expenses enable row level security;
alter table public.customer_quotations enable row level security;

-- حذف policyهای آزمایشی و دسترسی‌های باز
do $$
declare
  r record;
begin
  for r in
    select tablename, policyname
    from pg_policies
    where schemaname = 'public'
      and (
        policyname like 'authenticated_all_%'
        or policyname like 'dev_%'
      )
  loop
    execute format(
      'drop policy if exists %I on public.%I',
      r.policyname,
      r.tablename
    );
  end loop;
end $$;

-- دسترسی کامل فقط برای کارکنان، آن هم فقط روی جدول‌های عملیاتی
do $$
declare
  table_name text;
  policy_name text;
begin
  foreach table_name in array array[
    'job_needs',
    'workshop_consumables',
    'workshop_consumable_movements',
    'expenses',
    'service_history',
    'purchase_items',
    'warranties',
    'work_logs',
    'contracts',
    'invoices',
    'invoice_items',
    'pricing_rules',
    'controller_lab',
    'service_plans',
    'crm_activities',
    'quotation_items',
    'payments',
    'customers',
    'jobs',
    'service_requests',
    'customer_requests'
  ]
  loop
    policy_name := table_name || '_staff_all';

    if not exists (
      select 1
      from pg_policies
      where schemaname = 'public'
        and tablename = table_name
        and policyname = policy_name
    ) then
      execute format(
        'create policy %I on public.%I
         for all to authenticated
         using (public.is_staff())
         with check (public.is_staff())',
        policy_name,
        table_name
      );
    end if;
  end loop;
end $$;

-- کارمندها بتوانند پروفایل‌ها را بخوانند
do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'user_profiles'
      and policyname = 'user_profiles_staff_select'
  ) then
    create policy user_profiles_staff_select
      on public.user_profiles
      for select to authenticated
      using (public.is_staff());
  end if;
end $$;

-- جلوگیری از ساخت یا تغییر نقش حساس توسط مشتری
create or replace function public.prevent_role_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  current_role public.user_role;
begin
  -- اجرای داخلی از service_role یا SQL Editor
  if auth.uid() is null then
    return new;
  end if;

  -- در ثبت‌نام عمومی، فقط customer مجاز است
  if tg_op = 'INSERT' then
    if new.role is null then
      new.role := 'customer';
    elsif new.role <> 'customer' then
      raise exception 'only customer role is allowed during signup';
    end if;

    return new;
  end if;

  -- در update، فقط admin اجازه تغییر role دارد
  select role
    into current_role
  from public.user_profiles
  where id = auth.uid();

  if current_role <> 'admin'
     and new.role is distinct from old.role then
    raise exception 'role change not allowed';
  end if;

  return new;
end;
$$;

drop trigger if exists trg_prevent_role_change
on public.user_profiles;

create trigger trg_prevent_role_change
before insert or update on public.user_profiles
for each row
execute function public.prevent_role_change();

commit;
