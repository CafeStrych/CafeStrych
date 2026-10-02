-- Uruchom raz w Supabase SQL Editor.
alter table public.bookings add column if not exists guests_count integer;
alter table public.bookings add column if not exists room text;
alter table public.bookings drop constraint if exists bookings_guests_positive;
alter table public.bookings add constraint bookings_guests_positive check (guests_count is null or guests_count > 0);
alter table public.bookings drop constraint if exists bookings_room_valid;
alter table public.bookings add constraint bookings_room_valid check (room is null or room in ('Mała salka','Duża salka','Góra'));

-- Twarda blokada nakładających się rezerwacji tej samej strefy.
create extension if not exists btree_gist;
alter table public.bookings drop constraint if exists bookings_no_overlap;
alter table public.bookings add constraint bookings_no_overlap exclude using gist (
  room with =,
  tstzrange(start_at, end_at, '[)') with &&
) where (room is not null);
