-- Immutable record of every auth event. Rows are never updated or deleted.
create table public.audit_log (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid references public.users(id) on delete set null, -- keep log even if user deleted
  event_type  text not null check (event_type in (
                'REGISTER',
                'LOGIN_SUCCESS',
                'LOGIN_FAILURE',
                'LOGOUT',
                'TOKEN_REFRESH',
                'PASSWORD_CHANGE',
                'PASSWORD_RESET_REQUEST',
                'PASSWORD_RESET_COMPLETE',
                'EMAIL_VERIFY',
                'ACCOUNT_LOCKED'
              )),
  ip_address  text,
  user_agent  text,
  metadata    jsonb not null default '{}',  -- event-specific context (e.g. failure reason)
  created_at  timestamptz not null default now()
);

-- Queries will always filter by user and sort by time
create index audit_log_user_id_idx   on public.audit_log(user_id);
create index audit_log_created_idx   on public.audit_log(created_at desc);
create index audit_log_event_idx     on public.audit_log(event_type);

comment on table public.audit_log is
  'Append-only forensics trail. Never UPDATE or DELETE rows from this table.';