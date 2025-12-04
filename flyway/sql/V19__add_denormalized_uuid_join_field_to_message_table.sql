BEGIN;

-- Add the new UUID columns
ALTER TABLE public.messages 
ADD COLUMN user_uuid uuid;
ALTER TABLE public.messages 
ADD COLUMN conversation_uuid uuid;
ALTER TABLE public.messages 
ADD COLUMN previous_uuid uuid;

-- Drop the existing chain trigger
DROP TRIGGER IF EXISTS trg_messages_chain ON public.messages;
DROP FUNCTION IF EXISTS public.chain_messages();

-- Create a combined trigger function for all insert logic
CREATE OR REPLACE FUNCTION public.messages_before_insert()
RETURNS TRIGGER AS $$
BEGIN
    -- Chain messages: set previous_id to the last message in conversation
    SELECT id
    INTO NEW.previous_id
    FROM public.messages
    WHERE conversation_id = NEW.conversation_id
      AND id < NEW.id
    ORDER BY id DESC
    LIMIT 1;

    -- Populate user_uuid from users table
    SELECT uuid INTO NEW.user_uuid
    FROM public.users
    WHERE id = NEW.user_id;
    
    -- Populate conversation_uuid from conversations table
    SELECT uuid INTO NEW.conversation_uuid
    FROM public.conversations
    WHERE id = NEW.conversation_id;
    
    -- Populate previous_uuid from messages table (if previous_id was set above)
    IF NEW.previous_id IS NOT NULL THEN
        SELECT uuid INTO NEW.previous_uuid
        FROM public.messages
        WHERE id = NEW.previous_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER trg_messages_before_insert
    BEFORE INSERT ON public.messages
    FOR EACH ROW
    EXECUTE FUNCTION public.messages_before_insert();

-- Populate user_uuid for all existing messages
UPDATE public.messages m
SET user_uuid = u.uuid
FROM public.users u
WHERE m.user_id = u.id;

-- Populate conversation_uuid for all existing messages
UPDATE public.messages m
SET conversation_uuid = c.uuid
FROM public.conversations c
WHERE m.conversation_id = c.id;

-- Populate previous_uuid for all existing messages that have a previous message
UPDATE public.messages m
SET previous_uuid = pm.uuid
FROM public.messages pm
WHERE m.previous_id = pm.id;

-- Add the NOT NULL constraint
ALTER TABLE public.messages 
ALTER COLUMN user_uuid SET NOT NULL;

ALTER TABLE public.messages 
ALTER COLUMN conversation_uuid SET NOT NULL;

COMMIT;