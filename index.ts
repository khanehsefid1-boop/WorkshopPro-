// Supabase Auth "Send SMS Hook" -> Kavenegar Verify Lookup API
//
// این فانکشن بین Supabase Auth و سرویس اعتبارسنجی کاوه‌نگار پل می‌زنه.
// Supabase وقتی کاربر signInWithOtp({ phone }) صدا می‌زنه، این هوک رو با
// { user, sms: { otp } } صدا می‌کنه. ما OTP رو می‌گیریم و از طریق کاوه‌نگار
// با متد verify/lookup (که برای همین کار طراحی شده) می‌فرستیم.
//
// نصب: این فایل رو با دستور زیر دیپلوی کن:
//   supabase functions deploy send-sms-hook --no-verify-jwt
//
// بعد تو Dashboard -> Authentication -> Hooks -> Send SMS hook
// این Edge Function رو انتخاب کن و Secret تولیدشده (v1,whsec_...) رو
// تو Environment Variable با اسم SEND_SMS_HOOK_SECRET ست کن.
//
// همچنین این‌ها رو به‌عنوان Secret ست کن (supabase secrets set):
//   KAVENEGAR_API_KEY    -> از پنل کاوه‌نگار، بخش "حساب من"
//   KAVENEGAR_TEMPLATE   -> اسم الگویی که تو بخش "اعتبار سنجی" ساختی
//                           (مثلاً WorkshopProLogin) و تایید شده

import { Webhook } from "npm:standardwebhooks@1.0.0";

const KAVENEGAR_API_KEY = Deno.env.get("KAVENEGAR_API_KEY")!;
const KAVENEGAR_TEMPLATE = Deno.env.get("KAVENEGAR_TEMPLATE")!;
const HOOK_SECRET = Deno.env.get("SEND_SMS_HOOK_SECRET")!;

// ارسال OTP از طریق متد verify/lookup کاوه‌نگار (مخصوص کد تایید)
async function sendKavenegarOtp(phone: string, otp: string) {
  // شماره باید بدون + و بدون کد کشور باشه، مثل 09121234567
  const normalizedPhone = phone.replace(/^\+?98/, "0").replace(/^\+/, "");

  const url = new URL(
    `https://api.kavenegar.com/v1/${KAVENEGAR_API_KEY}/verify/lookup.json`,
  );
  url.searchParams.set("receptor", normalizedPhone);
  url.searchParams.set("token", otp);
  url.searchParams.set("template", KAVENEGAR_TEMPLATE);

  const res = await fetch(url.toString());
  const data = await res.json();

  if (!res.ok || data?.return?.status !== 200) {
    throw new Error(
      "Kavenegar error: " + res.status + " " + JSON.stringify(data),
    );
  }
}

Deno.serve(async (req) => {
  const payload = await req.text();
  const headers = Object.fromEntries(req.headers);

  // تایید امضای درخواست (اطمینان از اینکه واقعاً از طرف Supabase اومده)
  try {
    const wh = new Webhook(HOOK_SECRET);
    wh.verify(payload, headers);
  } catch (err) {
    return new Response(
      JSON.stringify({ error: { http_code: 401, message: "Invalid signature" } }),
      { status: 401, headers: { "Content-Type": "application/json" } },
    );
  }

  try {
    const body = JSON.parse(payload);
    const phone: string = body.user?.phone;
    const otp: string = body.sms?.otp;

    if (!phone || !otp) {
      throw new Error("Missing phone or otp in hook payload");
    }

    await sendKavenegarOtp(phone, otp);

    return new Response(JSON.stringify({}), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error(err);
    return new Response(
      JSON.stringify({
        error: { http_code: 500, message: "خطا در ارسال کد از طریق کاوه‌نگار: " + err.message },
      }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }
});
