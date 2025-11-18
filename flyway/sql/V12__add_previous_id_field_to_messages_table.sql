ALTER TABLE public.messages
    ADD COLUMN previous_id INTEGER REFERENCES public.messages(id);

CREATE OR REPLACE FUNCTION public.rechain_messages()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.messages
    SET previous_id = OLD.previous_id
    WHERE previous_id = OLD.id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_messages_rechain
    BEFORE DELETE ON public.messages
    FOR EACH ROW
    EXECUTE FUNCTION public.rechain_messages();

CREATE INDEX idx_messages_previous_id
    ON public.messages(previous_id);
