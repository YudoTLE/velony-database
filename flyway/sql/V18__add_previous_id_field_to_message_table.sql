BEGIN;

ALTER TABLE public.messages
ADD COLUMN previous_id INTEGER REFERENCES public.messages(id);

CREATE INDEX idx_messages_previous_id
    ON public.messages(previous_id);


CREATE FUNCTION public.rechain_messages()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.messages
    SET previous_id = OLD.previous_id
    WHERE previous_id = OLD.id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_messages_rechain
    AFTER DELETE ON public.messages
    FOR EACH ROW
    EXECUTE FUNCTION public.rechain_messages();


CREATE FUNCTION public.chain_messages()
RETURNS trigger AS $$
BEGIN
    SELECT id
    INTO NEW.previous_id
    FROM public.messages
    WHERE conversation_id = NEW.conversation_id
      AND id < NEW.id
    ORDER BY id DESC
    LIMIT 1;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_messages_chain
    BEFORE INSERT ON public.messages
    FOR EACH ROW
    EXECUTE FUNCTION public.chain_messages();


UPDATE public.messages m
SET previous_id = sub.prev_id
FROM (
    SELECT
        id,
        LAG(id) OVER (PARTITION BY conversation_id ORDER BY id) AS prev_id
    FROM public.messages
) AS sub
WHERE m.id = sub.id;

COMMIT;