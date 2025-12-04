BEGIN;

ALTER TABLE public.users 
ADD COLUMN deleted_at TIMESTAMP DEFAULT NULL;
ALTER TABLE public.conversations 
ADD COLUMN deleted_at TIMESTAMP DEFAULT NULL;

CREATE INDEX idx_users_deleted_at
ON public.users (deleted_at);
CREATE INDEX idx_conversations_deleted_at
ON public.conversations (deleted_at);

COMMIT;