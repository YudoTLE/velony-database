-- Add UNIQUE constraint to phone_number column in users table
ALTER TABLE public.users 
ADD CONSTRAINT users_phone_number_unique UNIQUE (phone_number);