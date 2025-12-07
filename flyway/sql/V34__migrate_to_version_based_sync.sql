BEGIN;

DELETE FROM public.users;
DELETE FROM public.messages;
DELETE FROM public.conversations;
DELETE FROM public.user_conversations;

CREATE SEQUENCE version_seq;

CREATE OR REPLACE FUNCTION public.next_version()
RETURNS BIGINT AS $$
BEGIN
    RETURN nextval('version_seq');
END;
$$ LANGUAGE plpgsql;

ALTER TABLE public.users
ADD COLUMN version BIGINT NOT NULL;
ALTER TABLE public.messages 
ADD COLUMN version BIGINT NOT NULL;
ALTER TABLE public.conversations 
ADD COLUMN version BIGINT NOT NULL;
ALTER TABLE public.user_conversations 
ADD COLUMN version BIGINT NOT NULL;

CREATE OR REPLACE FUNCTION public.set_version()
RETURNS TRIGGER AS $$
BEGIN
    NEW.version = next_version();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_version_trigger
    BEFORE INSERT OR UPDATE ON public.users
    FOR EACH ROW
    EXECUTE FUNCTION set_version();
CREATE TRIGGER messages_version_trigger
    BEFORE INSERT OR UPDATE ON public.messages
    FOR EACH ROW
    EXECUTE FUNCTION set_version();
CREATE TRIGGER conversations_version_trigger
    BEFORE INSERT OR UPDATE ON public.conversations
    FOR EACH ROW
    EXECUTE FUNCTION set_version();
CREATE TRIGGER user_conversations_version_trigger
    BEFORE INSERT OR UPDATE ON public.user_conversations
    FOR EACH ROW
    EXECUTE FUNCTION set_version();

COMMIT;
