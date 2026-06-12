create table public.budgets (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid references public.users(id) on delete cascade not null,
  category_id   uuid references public.categories(id) on delete cascade not null,
  limit_amount  numeric(12,2) not null check (limit_amount > 0),
  spent_amount  numeric(12,2) not null default 0,
  month         int not null check (month between 1 and 12),
  year          int not null check (year >= 2020),
  created_at    timestamptz not null default now(),
  unique (user_id, category_id, month, year)
);

create index budgets_user_id_idx on public.budgets(user_id);