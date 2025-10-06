CREATE TABLE public.conversations (
    id serial PRIMARY KEY,
    uuid uuid DEFAULT gen_random_uuid () NOT NULL UNIQUE,
    name varchar(50) NOT NULL,
    description varchar(1000) NOT NULL,
    group_picture_url text,
    created_at timestamp DEFAULT now(),
    updated_at timestamp DEFAULT now()
);

CREATE TRIGGER trg_conversations_set_updated_at
    BEFORE UPDATE ON public.conversations
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at ();