BEGIN;

ALTER TABLE public.messages
    DROP CONSTRAINT IF EXISTS messages_user_id_fkey;

ALTER TABLE public.messages
    ADD CONSTRAINT messages_user_id_fkey
        FOREIGN KEY (user_id)
        REFERENCES public.users(id)
        ON DELETE CASCADE;

COMMIT;
