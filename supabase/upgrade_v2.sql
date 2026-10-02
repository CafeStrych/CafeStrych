-- URUCHOM TEN PLIK RAZ w Supabase SQL Editor przed wgraniem aplikacji v2.
alter table public.profiles add column if not exists role text not null default 'user';
update public.profiles set role='admin', full_name='Daniel' where lower(full_name) like 'daniel%';
create table if not exists public.employees(id uuid primary key default gen_random_uuid(),full_name text not null,profile_id uuid unique references public.profiles(id) on delete set null,active boolean not null default true,created_at timestamptz not null default now());
create table if not exists public.work_shifts(id uuid primary key default gen_random_uuid(),employee_id uuid not null references public.employees(id) on delete cascade,shift_date date not null,start_time time not null,end_time time not null,created_by uuid not null references public.profiles(id),created_at timestamptz not null default now(),unique(employee_id,shift_date),check(end_time>start_time));
alter table public.employees enable row level security;alter table public.work_shifts enable row level security;
grant select on public.employees,public.work_shifts to authenticated;grant insert,update,delete on public.employees,public.work_shifts to authenticated;grant update on public.profiles to authenticated;
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path=public as $$select exists(select 1 from public.profiles where id=auth.uid() and role='admin')$$;
drop policy if exists "employees read" on public.employees;create policy "employees read" on public.employees for select to authenticated using(true);
drop policy if exists "employees admin write" on public.employees;create policy "employees admin write" on public.employees for all to authenticated using(public.is_admin()) with check(public.is_admin());
drop policy if exists "shifts read" on public.work_shifts;create policy "shifts read" on public.work_shifts for select to authenticated using(true);
drop policy if exists "shifts admin write" on public.work_shifts;create policy "shifts admin write" on public.work_shifts for all to authenticated using(public.is_admin()) with check(public.is_admin());
drop policy if exists "profiles admin update" on public.profiles;create policy "profiles admin update" on public.profiles for update to authenticated using(public.is_admin()) with check(public.is_admin());
-- Zapewnia profil z rolą user nowym kontom
create or replace function public.new_user_profile() returns trigger language plpgsql security definer set search_path=public as $$begin insert into public.profiles(id,full_name,role) values(new.id,coalesce(new.raw_user_meta_data->>'full_name',split_part(new.email,'@',1)),'user') on conflict do nothing; return new; end$$;
drop trigger if exists on_auth_user_created on auth.users;create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.new_user_profile();
