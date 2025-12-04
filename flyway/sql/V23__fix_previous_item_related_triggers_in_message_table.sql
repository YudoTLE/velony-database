BEGIN;

CREATE OR REPLACE FUNCTION public.messages_before_insert()
RETURNS TRIGGER AS $$
BEGIN
    -- Chain messages: set previous_id to the last message in conversation
    SELECT id, uuid
    INTO NEW.previous_id, NEW.previous_uuid
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
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS rechain_messages ON public.messages;
DROP FUNCTION IF EXISTS public.trg_messages_rechain();

CREATE FUNCTION public.messages_after_delete()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.messages
    SET
        previous_id = OLD.previous_id,
        previous_uuid = OLD.previous_uuid
    WHERE previous_id = OLD.id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_messages_after_delete
    AFTER DELETE ON public.messages
    FOR EACH ROW
    EXECUTE FUNCTION public.messages_after_delete();

COMMIT;