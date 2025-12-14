BEGIN;

DROP INDEX IF EXISTS public.idx_messages_version_id;

CREATE INDEX idx_messages_conversation_id_id ON public.messages(conversation_id, id);
CREATE INDEX idx_messages_conversation_id_version ON public.messages(conversation_id, version);

COMMIT;
