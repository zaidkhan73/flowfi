create or replace function seed_default_categories()
returns trigger as $$
begin
  insert into public.categories (user_id, name, icon, color, type, is_default) values
    (new.id, 'Food & Dining',   'tools-kitchen-2', '#D85A30', 'expense', true),
    (new.id, 'Transport',       'car',             '#378ADD', 'expense', true),
    (new.id, 'Housing & Rent',  'home',            '#534AB7', 'expense', true),
    (new.id, 'Shopping',        'shopping-bag',    '#D4537E', 'expense', true),
    (new.id, 'Entertainment',   'device-tv',       '#1D9E75', 'expense', true),
    (new.id, 'Health',          'heart',           '#E24B4A', 'expense', true),
    (new.id, 'Education',       'book',            '#BA7517', 'expense', true),
    (new.id, 'Utilities',       'bolt',            '#888780', 'expense', true),
    (new.id, 'Travel',          'plane',           '#639922', 'expense', true),
    (new.id, 'Other Expenses',  'dots',            '#5F5E5A', 'expense', true),
    (new.id, 'Salary',          'briefcase',       '#1D9E75', 'income',  true),
    (new.id, 'Freelance',       'code',            '#534AB7', 'income',  true),
    (new.id, 'Investments',     'trending-up',     '#BA7517', 'income',  true),
    (new.id, 'Other Income',    'plus',            '#888780', 'income',  true);
  return new;
end;
$$ language plpgsql security definer;

-- Fires on YOUR users table — no Supabase Auth dependency
create trigger on_user_created
  after insert on public.users
  for each row execute function seed_default_categories();