BEGIN;

DROP INDEX IF EXISTS public.idx_messages_conversation_id_created_at_id;
DROP INDEX IF EXISTS public.idx_messages_conversation_id_updated_at_id;
DROP INDEX IF EXISTS public.idx_user_conversations_updated_at_id;
DROP INDEX IF EXISTS public.idx_users_updated_at_id;

CREATE INDEX idx_messages_version_id ON public.messages(version, id);
CREATE INDEX idx_user_conversations_version_id ON public.user_conversations(version, id);
CREATE INDEX idx_conversations_version_id ON public.conversations(version, id);
CREATE INDEX idx_users_version_id ON public.users(version, id);

COMMIT;
