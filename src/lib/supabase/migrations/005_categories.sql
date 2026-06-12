create table public.categories (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid references public.users(id) on delete cascade not null,
  name        text not null,
  icon        text not null default 'circle',
  color       text not null default '#7F77DD',
  type        text not null check (type in ('income', 'expense')),
  is_default  boolean not null default false,
  created_at  timestamptz not null default now()
);

create index categories_user_id_idx on public.categories(user_id);