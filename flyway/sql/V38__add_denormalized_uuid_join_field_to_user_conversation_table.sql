BEGIN;

-- Add the new UUID columns
ALTER TABLE public.user_conversations 
ADD COLUMN user_uuid uuid;
ALTER TABLE public.user_conversations 
ADD COLUMN conversation_uuid uuid;

-- Create a combined trigger function for all insert logic
CREATE OR REPLACE FUNCTION public.user_conversations_before_insert()
RETURNS TRIGGER AS $$
BEGIN
    -- Populate user_uuid from users table
    SELECT uuid INTO NEW.user_uuid
    FROM public.users
    WHERE id = NEW.user_id;
    
    -- Populate conversation_uuid from conversations table
    SELECT uuid INTO NEW.conversation_uuid
    FROM public.conversations
    WHERE id = NEW.conversation_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER trg_user_conversations_before_insert
    BEFORE INSERT ON public.user_conversations
    FOR EACH ROW
    EXECUTE FUNCTION public.user_conversations_before_insert();

-- Populate user_uuid for all existing user conversations
UPDATE public.user_conversations m
SET user_uuid = u.uuid
FROM public.users u
WHERE m.user_id = u.id;

-- Populate conversation_uuid for all existing user conversations
UPDATE public.user_conversations m
SET conversation_uuid = c.uuid
FROM public.conversations c
WHERE m.conversation_id = c.id;

-- Add the NOT NULL constraint
ALTER TABLE public.user_conversations 
ALTER COLUMN user_uuid SET NOT NULL;

ALTER TABLE public.user_conversations 
ALTER COLUMN conversation_uuid SET NOT NULL;

COMMIT;