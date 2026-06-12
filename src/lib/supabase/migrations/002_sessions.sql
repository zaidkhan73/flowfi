-- Server-side session records. Enables revocation and CSRF tracking.
create table public.sessions (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid references public.users(id) on delete cascade not null,
  csrf_token  text not null,               -- double-submit cookie value
  ip_address  text,
  user_agent  text,
  expires_at  timestamptz not null,
  created_at  timestamptz not null default now()
);

create index sessions_user_id_idx  on public.sessions(user_id);
create index sessions_expires_idx  on public.sessions(expires_at);

comment on table public.sessions is
  'Active sessions. One row per logged-in browser. Deleted on logout or expiry.';