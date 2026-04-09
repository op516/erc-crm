const { createClient } = supabase;
window.supabase = createClient(
  'https://TON_PROJECT_URL.supabase.co',
  'TA_CLE_ANON'
);
