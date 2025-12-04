BEGIN;

DELETE FROM public.messages
WHERE user_id IS NULL;

ALTER TABLE public.messages
ALTER COLUMN user_id SET NOT NULL;

COMMIT;