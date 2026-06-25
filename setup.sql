-- 花立山養鰻 ERP v2 テーブル作成SQL
-- Supabase SQL Editorで以下を全てコピーして実行してください

CREATE TABLE IF NOT EXISTS erp_pools (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  capacity INTEGER DEFAULT 0,
  current INTEGER DEFAULT 0,
  weight NUMERIC DEFAULT 0,
  status TEXT DEFAULT 'normal',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS erp_stock_in (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  date DATE NOT NULL,
  supplier TEXT,
  pool_id TEXT,
  lot TEXT,
  qty INTEGER DEFAULT 0,
  kg NUMERIC DEFAULT 0,
  avg_size TEXT,
  staff TEXT,
  memo TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS erp_shipping (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  date DATE NOT NULL,
  destination TEXT,
  pool_id TEXT,
  qty INTEGER DEFAULT 0,
  kg NUMERIC DEFAULT 0,
  price NUMERIC DEFAULT 0,
  memo TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS erp_feeding (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  date DATE NOT NULL,
  pool_id TEXT,
  feed_type TEXT,
  amount_kg NUMERIC DEFAULT 0,
  staff TEXT,
  memo TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS erp_water_quality (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  date DATE NOT NULL,
  pool_id TEXT,
  temp NUMERIC,
  ph NUMERIC,
  do_level NUMERIC,
  nh3 NUMERIC,
  no2 NUMERIC,
  salt NUMERIC,
  exchange INTEGER,
  staff TEXT,
  memo TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS erp_deaths (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  date DATE NOT NULL,
  pool_id TEXT,
  count INTEGER DEFAULT 0,
  cause TEXT,
  staff TEXT,
  memo TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS erp_medicines (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  name TEXT NOT NULL,
  pool_id TEXT,
  use_date DATE,
  amount TEXT,
  purpose TEXT,
  withdraw_days INTEGER DEFAULT 0,
  clear_date DATE,
  status TEXT DEFAULT 'active',
  staff TEXT,
  memo TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS erp_processing (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  date DATE NOT NULL,
  product TEXT,
  raw_kg NUMERIC DEFAULT 0,
  yield_kg NUMERIC DEFAULT 0,
  qty INTEGER DEFAULT 0,
  staff TEXT,
  memo TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS erp_haccp (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  date DATE NOT NULL,
  check_type TEXT,
  result TEXT,
  staff TEXT,
  memo TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS erp_finance (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  date DATE NOT NULL,
  type TEXT,
  category TEXT,
  amount NUMERIC DEFAULT 0,
  description TEXT,
  memo TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS erp_subsidies (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  name TEXT,
  equipment TEXT,
  order_date DATE,
  delivery_date DATE,
  payment_date DATE,
  amount NUMERIC DEFAULT 0,
  status TEXT DEFAULT 'pending',
  memo TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS erp_permit (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  number TEXT,
  year INTEGER,
  annual INTEGER DEFAULT 0,
  used INTEGER DEFAULT 0,
  expiry DATE,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS無効化（社内システムのため）
ALTER TABLE erp_pools DISABLE ROW LEVEL SECURITY;
ALTER TABLE erp_stock_in DISABLE ROW LEVEL SECURITY;
ALTER TABLE erp_shipping DISABLE ROW LEVEL SECURITY;
ALTER TABLE erp_feeding DISABLE ROW LEVEL SECURITY;
ALTER TABLE erp_water_quality DISABLE ROW LEVEL SECURITY;
ALTER TABLE erp_deaths DISABLE ROW LEVEL SECURITY;
ALTER TABLE erp_medicines DISABLE ROW LEVEL SECURITY;
ALTER TABLE erp_processing DISABLE ROW LEVEL SECURITY;
ALTER TABLE erp_haccp DISABLE ROW LEVEL SECURITY;
ALTER TABLE erp_finance DISABLE ROW LEVEL SECURITY;
ALTER TABLE erp_subsidies DISABLE ROW LEVEL SECURITY;
ALTER TABLE erp_permit DISABLE ROW LEVEL SECURITY;

-- 池初期データ挿入
INSERT INTO erp_pools (id, name, capacity, current, weight, status) VALUES
  ('P01', '第1池', 10000, 8200, 820, 'normal'),
  ('P02', '第2池', 10000, 7500, 750, 'normal'),
  ('P03', '第3池', 8000, 6100, 610, 'warning'),
  ('P04', '第4池（杉樽）', 5000, 4200, 420, 'normal'),
  ('P05', '委託池（イールF）', 12000, 9800, 980, 'normal')
ON CONFLICT (id) DO NOTHING;

-- 許可枠初期データ
INSERT INTO erp_permit (number, year, annual, used, expiry) VALUES
  ('FKO-2026-0042', 2026, 50000, 32000, '2027-03-31')
ON CONFLICT DO NOTHING;
