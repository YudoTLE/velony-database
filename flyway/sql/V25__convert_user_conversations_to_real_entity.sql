BEGIN;

-- Drop the existing composite primary key
ALTER TABLE public.user_conversations 
DROP CONSTRAINT user_conversations_pkey;

-- Add the new id column as primary key
ALTER TABLE public.user_conversations 
ADD COLUMN id SERIAL PRIMARY KEY;

-- Add other new columns
ALTER TABLE public.user_conversations 
ADD COLUMN uuid UUID DEFAULT gen_random_uuid() NOT NULL UNIQUE;

ALTER TABLE public.user_conversations
ADD COLUMN updated_at TIMESTAMP DEFAULT NULL;

ALTER TABLE public.user_conversations
ADD COLUMN deleted_at TIMESTAMP DEFAULT NULL;

-- Add unique constraint on the original composite key
ALTER TABLE public.user_conversations 
ADD CONSTRAINT user_conversations_user_conversation_unique 
UNIQUE (user_id, conversation_id);

-- Add index on (updated_at, id)
CREATE INDEX idx_user_conversations_updated_at_id 
ON public.user_conversations(updated_at, id);

-- Add index on (deleted_at)
CREATE INDEX idx_user_conversations_deleted_at 
ON public.user_conversations(deleted_at);

COMMIT;