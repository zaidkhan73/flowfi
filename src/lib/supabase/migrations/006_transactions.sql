create table public.transactions (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid references public.users(id) on delete cascade not null,
  category_id  uuid references public.categories(id) on delete set null,
  amount       numeric(12,2) not null check (amount > 0),
  type         text not null check (type in ('income','expense')),
  description  text,
  date         date not null default current_date,
  source       text not null default 'manual' check (source in ('manual','csv')),
  created_at   timestamptz not null default now()
);

create index transactions_user_id_idx on public.transactions(user_id);
create index transactions_date_idx    on public.transactions(date desc);