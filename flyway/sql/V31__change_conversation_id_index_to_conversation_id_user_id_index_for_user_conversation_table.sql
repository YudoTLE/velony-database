BEGIN;

DROP INDEX IF EXISTS public.idx_user_conversations_conversation_id;

CREATE INDEX idx_user_conversation_conversation_id_user_id
ON public.user_conversations(conversation_id, user_id);

COMMIT;
