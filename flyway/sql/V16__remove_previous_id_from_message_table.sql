DROP TRIGGER IF EXISTS trigger_set_previous_message ON public.messages;
DROP TRIGGER IF EXISTS trg_messages_rechain ON public.messages;

DROP FUNCTION IF EXISTS set_previous_message();
DROP FUNCTION IF EXISTS public.rechain_messages();

DROP INDEX IF EXISTS idx_messages_previous_id;

ALTER TABLE public.messages
    DROP COLUMN IF EXISTS previous_id;
