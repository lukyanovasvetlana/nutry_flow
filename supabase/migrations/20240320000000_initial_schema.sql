-- Создание таблицы профилей пользователей
create table public.profiles (
  id uuid references auth.users on delete cascade not null primary key,
  email text unique not null,
  full_name text,
  avatar_url text,
  gender text check (gender in ('male', 'female', 'other')),
  birth_date date,
  height numeric,
  weight numeric,
  activity_level text check (activity_level in ('sedentary', 'light', 'moderate', 'active', 'very_active')),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Включаем RLS (Row Level Security)
alter table public.profiles enable row level security;

-- Создаем политики безопасности
create policy "Users can view their own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can update their own profile"
  on public.profiles for update
  using (auth.uid() = id);

-- Создаем функцию для автоматического создания профиля при регистрации
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email);
  return new;
end;
$$ language plpgsql security definer;

-- Создаем триггер для автоматического создания профиля
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user(); 