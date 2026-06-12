-- The users table
create table public.users (
  id               uuid primary key default gen_random_uuid(),

  email_encrypted  text not null,
  email_hash       text not null unique,   

  password_hash    text,          

  -- Profile fields 
  full_name        text,
  avatar_url       text,
  currency         text not null default 'INR',

  -- Access control
  role             text not null default 'user' check (role in ('user', 'admin')),

  -- Email verification
  is_verified      boolean not null default false,
  verify_token     text,                  
  verify_token_expires_at timestamptz,

  is_locked boolean not null default false,
  failed_attempts integer not null default 0,
  google_id text unique,                  -- for Google OAuth

  -- Password reset
  reset_token      text,                   
  reset_token_expires_at  timestamptz,

  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now()
);

-- Fast lookup by email hash on every login
create index users_email_hash_idx on public.users(email_hash);

comment on column public.users.email_encrypted is
  'AES-256-GCM encrypted email — decrypted only when displaying to the user';
comment on column public.users.email_hash is
  'HMAC-SHA256 of the email — used for WHERE lookups without decrypting';