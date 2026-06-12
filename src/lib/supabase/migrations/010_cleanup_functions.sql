-- Deletes expired sessions and their associated refresh tokens (cascade handles tokens)
create or replace function cleanup_expired_sessions()
returns void as $$
begin
  delete from public.sessions
  where expires_at < now();
end;
$$ language plpgsql security definer;

-- Revokes refresh tokens that are expired (belt-and-suspenders alongside session cascade)
create or replace function cleanup_expired_tokens()
returns void as $$
begin
  update public.refresh_tokens
  set    is_revoked = true
  where  expires_at < now()
  and    is_revoked  = false;
end;
$$ language plpgsql security definer;

comment on function cleanup_expired_sessions is
  'Called by cron Edge Function nightly. Removes expired session rows.';