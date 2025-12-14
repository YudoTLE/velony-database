BEGIN;

DROP INDEX IF EXISTS public.idx_messages_version_id;

CREATE INDEX idx_messages_conversation_id_id_version ON public.messages(conversation_id, id, version);

COMMIT;
