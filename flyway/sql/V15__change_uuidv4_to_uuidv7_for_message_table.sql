CREATE EXTENSION IF NOT EXISTS pg_uuidv7;

UPDATE public.messages
SET uuid = uuid_generate_v7();

ALTER TABLE public.messages
    ALTER COLUMN uuid SET DEFAULT uuid_generate_v7();
