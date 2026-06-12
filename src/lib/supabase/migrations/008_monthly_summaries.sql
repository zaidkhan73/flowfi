create table public.monthly_summaries (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid references public.users(id) on delete cascade not null,
  month           int not null check (month between 1 and 12),
  year            int not null check (year >= 2020),
  total_income    numeric(12,2) not null default 0,
  total_expenses  numeric(12,2) not null default 0,
  savings_rate    numeric(5,2)  not null default 0,
  top_categories  jsonb not null default '[]',
  generated_at    timestamptz not null default now(),
  unique (user_id, month, year)
);

create index monthly_summaries_user_id_idx on public.monthly_summaries(user_id);