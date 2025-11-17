CREATE TABLE public.messages (
    id serial PRIMARY KEY,
    uuid uuid DEFAULT gen_random_uuid () NOT NULL UNIQUE,
    user_id INTEGER REFERENCES public.users(id) ON DELETE SET NULL,
    conversation_id INTEGER NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    content text,
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);

CREATE TRIGGER trg_messages_set_updated_at
    BEFORE UPDATE ON public.messages
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at ();

CREATE INDEX idx_messages_conversation_id_created_at_id
    ON public.messages (conversation_id, created_at, id);

CREATE INDEX idx_messages_conversation_id_updated_at_id
    ON public.messages (conversation_id, updated_at, id);
