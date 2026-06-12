-- Refresh tokens: only the hash is stored.
create table public.refresh_tokens (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid references public.users(id) on delete cascade not null,
  session_id  uuid references public.sessions(id) on delete cascade not null,
  token_hash  text not null unique,        
  is_revoked  boolean not null default false,
  expires_at  timestamptz not null,
  created_at  timestamptz not null default now()
);

create index refresh_tokens_user_id_idx   on public.refresh_tokens(user_id);
create index refresh_tokens_token_hash_idx on public.refresh_tokens(token_hash);

comment on table public.refresh_tokens is
  'One row per issued refresh token. Rotated on every use — old row revoked, new row created.';