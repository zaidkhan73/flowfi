create or replace function update_budget_spent()
returns trigger as $$
declare
  v_month int;
  v_year  int;
begin
  if (TG_OP = 'DELETE') then
    v_month := extract(month from OLD.date);
    v_year  := extract(year  from OLD.date);
    update public.budgets
    set spent_amount = (
      select coalesce(sum(amount), 0)
      from   public.transactions
      where  user_id     = OLD.user_id
      and    category_id = OLD.category_id
      and    type        = 'expense'
      and    extract(month from date) = v_month
      and    extract(year  from date) = v_year
    )
    where user_id     = OLD.user_id
    and   category_id = OLD.category_id
    and   month       = v_month
    and   year        = v_year;
    return OLD;
  else
    v_month := extract(month from NEW.date);
    v_year  := extract(year  from NEW.date);
    update public.budgets
    set spent_amount = (
      select coalesce(sum(amount), 0)
      from   public.transactions
      where  user_id     = NEW.user_id
      and    category_id = NEW.category_id
      and    type        = 'expense'
      and    extract(month from date) = v_month
      and    extract(year  from date) = v_year
    )
    where user_id     = NEW.user_id
    and   category_id = NEW.category_id
    and   month       = v_month
    and   year        = v_year;
    return NEW;
  end if;
end;
$$ language plpgsql security definer;

create trigger trg_budget_spent
after insert or delete on public.transactions
for each row execute function update_budget_spent();