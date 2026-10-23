[
  {
    "format": "create policy authenticated_all_customers on public.customers as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_user_profiles on public.user_profiles as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_equipment on public.equipment as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_contracts on public.contracts as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_service_requests on public.service_requests as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_jobs on public.jobs as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_diagnosis on public.diagnosis as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_work_logs on public.work_logs as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_parts on public.parts as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_stock_movements on public.stock_movements as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_suppliers on public.suppliers as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_sourcing_requests on public.sourcing_requests as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_supplier_quotes on public.supplier_quotes as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_market_prices on public.market_prices as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_pricing_rules on public.pricing_rules as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_controller_lab on public.controller_lab as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_customer_quotations on public.customer_quotations as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_quotation_items on public.quotation_items as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy customers_self_signup_insert on public.customers as PERMISSIVE for INSERT to authenticated with check (true);"
  },
  {
    "format": "create policy authenticated_all_invoices on public.invoices as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_invoice_items on public.invoice_items as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_payments on public.payments as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_expenses on public.expenses as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_purchases on public.purchases as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_purchase_items on public.purchase_items as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_warranties on public.warranties as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_service_plans on public.service_plans as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_service_history on public.service_history as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy authenticated_all_crm_activities on public.crm_activities as PERMISSIVE for ALL to authenticated using (true) with check (true);"
  },
  {
    "format": "create policy dev_customers_insert on public.customers as PERMISSIVE for INSERT to anon with check (true);"
  },
  {
    "format": "create policy dev_customers_select on public.customers as PERMISSIVE for SELECT to anon using (true);"
  },
  {
    "format": "create policy dev_equipment_insert on public.equipment as PERMISSIVE for INSERT to anon with check (true);"
  },
  {
    "format": "create policy dev_equipment_select on public.equipment as PERMISSIVE for SELECT to anon using (true);"
  },
  {
    "format": "create policy dev_jobs_insert on public.jobs as PERMISSIVE for INSERT to anon with check (true);"
  },
  {
    "format": "create policy user_profiles_self_select on public.user_profiles as PERMISSIVE for SELECT to authenticated using ((id = auth.uid()));"
  },
  {
    "format": "create policy user_profiles_self_upsert on public.user_profiles as PERMISSIVE for INSERT to authenticated with check ((id = auth.uid()));"
  },
  {
    "format": "create policy user_profiles_self_update on public.user_profiles as PERMISSIVE for UPDATE to authenticated using ((id = auth.uid()));"
  },
  {
    "format": "create policy customers_self_select on public.customers as PERMISSIVE for SELECT to authenticated using (((id IN ( SELECT user_profiles.customer_id\n   FROM user_profiles\n  WHERE (user_profiles.id = auth.uid()))) OR (EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))));"
  },
  {
    "format": "create policy customers_customer_select on public.customers as PERMISSIVE for SELECT to authenticated using ((auth.uid() = auth_user_id));"
  },
  {
    "format": "create policy customers_customer_insert on public.customers as PERMISSIVE for INSERT to authenticated with check ((auth.uid() = auth_user_id));"
  },
  {
    "format": "create policy customers_customer_update on public.customers as PERMISSIVE for UPDATE to authenticated using ((auth.uid() = auth_user_id)) with check ((auth.uid() = auth_user_id));"
  },
  {
    "format": "create policy customer_requests_customer_select on public.customer_requests as PERMISSIVE for SELECT to authenticated using ((customer_id IN ( SELECT customers.id\n   FROM customers\n  WHERE (customers.auth_user_id = auth.uid()))));"
  },
  {
    "format": "create policy customer_requests_customer_insert on public.customer_requests as PERMISSIVE for INSERT to authenticated with check ((customer_id IN ( SELECT customers.id\n   FROM customers\n  WHERE (customers.auth_user_id = auth.uid()))));"
  },
  {
    "format": "create policy equipment_customer_select on public.equipment as PERMISSIVE for SELECT to authenticated using ((customer_id IN ( SELECT customers.id\n   FROM customers\n  WHERE (customers.auth_user_id = auth.uid()))));"
  },
  {
    "format": "create policy quotations_customer_select on public.customer_quotations as PERMISSIVE for SELECT to authenticated using (((customer_id IN ( SELECT user_profiles.customer_id\n   FROM user_profiles\n  WHERE (user_profiles.id = auth.uid()))) OR (EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))));"
  },
  {
    "format": "create policy quotations_customer_update_approve on public.customer_quotations as PERMISSIVE for UPDATE to authenticated using ((customer_id IN ( SELECT user_profiles.customer_id\n   FROM user_profiles\n  WHERE (user_profiles.id = auth.uid())))) with check ((customer_id IN ( SELECT user_profiles.customer_id\n   FROM user_profiles\n  WHERE (user_profiles.id = auth.uid()))));"
  },
  {
    "format": "create policy quotation_items_customer_select on public.quotation_items as PERMISSIVE for SELECT to authenticated using (((quotation_id IN ( SELECT customer_quotations.id\n   FROM customer_quotations\n  WHERE (customer_quotations.customer_id IN ( SELECT user_profiles.customer_id\n           FROM user_profiles\n          WHERE (user_profiles.id = auth.uid()))))) OR (EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))));"
  },
  {
    "format": "create policy invoices_customer_select on public.invoices as PERMISSIVE for SELECT to authenticated using (((customer_id IN ( SELECT user_profiles.customer_id\n   FROM user_profiles\n  WHERE (user_profiles.id = auth.uid()))) OR (EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))));"
  },
  {
    "format": "create policy payments_customer_select on public.payments as PERMISSIVE for SELECT to authenticated using (((customer_id IN ( SELECT user_profiles.customer_id\n   FROM user_profiles\n  WHERE (user_profiles.id = auth.uid()))) OR (EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))));"
  },
  {
    "format": "create policy service_requests_customer_insert on public.service_requests as PERMISSIVE for INSERT to authenticated with check ((customer_id IN ( SELECT user_profiles.customer_id\n   FROM user_profiles\n  WHERE (user_profiles.id = auth.uid()))));"
  },
  {
    "format": "create policy service_requests_customer_select on public.service_requests as PERMISSIVE for SELECT to authenticated using (((customer_id IN ( SELECT user_profiles.customer_id\n   FROM user_profiles\n  WHERE (user_profiles.id = auth.uid()))) OR (EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))));"
  },
  {
    "format": "create policy equipment_staff_all on public.equipment as PERMISSIVE for ALL to authenticated using ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))) with check ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role]))))));"
  },
  {
    "format": "create policy jobs_customer_select on public.jobs as PERMISSIVE for SELECT to authenticated using (((customer_id IN ( SELECT user_profiles.customer_id\n   FROM user_profiles\n  WHERE (user_profiles.id = auth.uid()))) OR (EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))));"
  },
  {
    "format": "create policy service_requests_staff_update on public.service_requests as PERMISSIVE for UPDATE to authenticated using ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))) with check ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role]))))));"
  },
  {
    "format": "create policy jobs_staff_insert on public.jobs as PERMISSIVE for INSERT to authenticated with check ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role]))))));"
  },
  {
    "format": "create policy diagnosis_staff_all on public.diagnosis as PERMISSIVE for ALL to authenticated using ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))) with check ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role]))))));"
  },
  {
    "format": "create policy parts_staff_all on public.parts as PERMISSIVE for ALL to authenticated using ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))) with check ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role]))))));"
  },
  {
    "format": "create policy stock_movements_staff_all on public.stock_movements as PERMISSIVE for ALL to authenticated using ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))) with check ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role]))))));"
  },
  {
    "format": "create policy sourcing_requests_staff_all on public.sourcing_requests as PERMISSIVE for ALL to authenticated using ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))) with check ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role]))))));"
  },
  {
    "format": "create policy jobs_staff_update on public.jobs as PERMISSIVE for UPDATE to authenticated using ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))) with check ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role]))))));"
  },
  {
    "format": "create policy suppliers_staff_all on public.suppliers as PERMISSIVE for ALL to authenticated using ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))) with check ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role]))))));"
  },
  {
    "format": "create policy supplier_quotes_staff_all on public.supplier_quotes as PERMISSIVE for ALL to authenticated using ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))) with check ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role]))))));"
  },
  {
    "format": "create policy market_prices_staff_all on public.market_prices as PERMISSIVE for ALL to authenticated using ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))) with check ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role]))))));"
  },
  {
    "format": "create policy purchases_staff_all on public.purchases as PERMISSIVE for ALL to authenticated using ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))) with check ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role]))))));"
  },
  {
    "format": "create policy quotations_staff_all on public.customer_quotations as PERMISSIVE for ALL to authenticated using ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role])))))) with check ((EXISTS ( SELECT 1\n   FROM user_profiles\n  WHERE ((user_profiles.id = auth.uid()) AND (user_profiles.role = ANY (ARRAY['admin'::user_role, 'technician'::user_role, 'warehouse_sales'::user_role]))))));"
  }
]
