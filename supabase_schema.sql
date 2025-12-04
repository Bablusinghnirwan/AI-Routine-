-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- 1. USERS (Public profile linked to auth.users)
create table if not exists public.users (
  id uuid references auth.users not null primary key,
  name text,
  email text,
  created_at timestamp with time zone default now()
);
alter table public.users enable row level security;
create policy "Users can read their own profile" on public.users
  for select using (auth.uid() = id);
create policy "Users can update their own profile" on public.users
  for update using (auth.uid() = id);

-- Function to handle new user creation
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.users (id, email, name)
  values (new.id, new.email, new.raw_user_meta_data->>'full_name');
  return new;
end;
$$ language plpgsql security definer;

-- Trigger to call the function on signup
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();


-- 2. TASKS
create table if not exists public.tasks (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users not null,
  title text not null,
  time timestamp with time zone not null,
  is_completed boolean default false,
  updated_at timestamp with time zone default now()
);
alter table public.tasks enable row level security;
create policy "Users can only access their own tasks" on public.tasks
  for all using (auth.uid() = user_id);


-- 3. DIARY
create table if not exists public.diary (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users not null,
  date timestamp with time zone not null,
  raw_text text,
  ai_summary text,
  ai_score double precision,
  sentiment text,
  updated_at timestamp with time zone default now()
);
alter table public.diary enable row level security;
create policy "Users can only access their own diary" on public.diary
  for all using (auth.uid() = user_id);


-- 4. GOALS
create table if not exists public.goals (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users not null,
  title text not null,
  description text,
  target_date timestamp with time zone,
  category text,
  ai_plan jsonb,
  daily_tasks text[],
  progress_score double precision,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);
alter table public.goals enable row level security;
create policy "Users can only access their own goals" on public.goals
  for all using (auth.uid() = user_id);


-- 5. SUMMARY
create table if not exists public.summary (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users not null,
  date timestamp with time zone not null,
  mood text,
  challenges text,
  proud text,
  ai_summary text,
  ai_score double precision,
  sentiment text,
  advice text,
  updated_at timestamp with time zone default now()
);
alter table public.summary enable row level security;
create policy "Users can only access their own summaries" on public.summary
  for all using (auth.uid() = user_id);


-- 6. PROGRESS
create table if not exists public.progress (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users not null,
  completed_tasks_in_goal int default 0,
  missed_tasks int default 0,
  discipline_score double precision default 0,
  consistency_rate double precision default 0,
  current_week int default 1,
  last_updated timestamp with time zone default now()
);
alter table public.progress enable row level security;
create policy "Users can only access their own progress" on public.progress
  for all using (auth.uid() = user_id);


-- 7. REALTIME SETUP
-- Add tables to the publication to enable Realtime updates
alter publication supabase_realtime add table public.tasks;
alter publication supabase_realtime add table public.diary;
alter publication supabase_realtime add table public.goals;
alter publication supabase_realtime add table public.summary;
alter publication supabase_realtime add table public.progress;
