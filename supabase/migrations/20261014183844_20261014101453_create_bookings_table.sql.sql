CREATE TABLE IF NOT EXISTS bookings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ref_code text UNIQUE NOT NULL DEFAULT ('VG-' || lpad((extract(epoch from now())::bigint % 100000)::text, 5, '0')),
  lead_name text NOT NULL,
  group_size int NOT NULL DEFAULT 1,
  whatsapp_number text NOT NULL,
  item_title text NOT NULL,
  item_subtitle text NOT NULL DEFAULT '',
  item_category text NOT NULL,
  partner_name text NOT NULL DEFAULT '',
  partner_details text NOT NULL DEFAULT '',
  booking_date text NOT NULL DEFAULT '',
  booking_time text NOT NULL DEFAULT '',
  price_mad numeric NOT NULL DEFAULT 0,
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'declined')),
  decline_reason text,
  voucher_code text,
  confirmed_at timestamptz,
  declined_at timestamptz,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_bookings" ON bookings;
CREATE POLICY "anon_select_bookings" ON bookings FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_bookings" ON bookings;
CREATE POLICY "anon_insert_bookings" ON bookings FOR INSERT
  TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_bookings" ON bookings;
CREATE POLICY "anon_update_bookings" ON bookings FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_delete_bookings" ON bookings;
CREATE POLICY "anon_delete_bookings" ON bookings FOR DELETE
  TO anon, authenticated USING (true);

CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_created_at ON bookings(created_at DESC);