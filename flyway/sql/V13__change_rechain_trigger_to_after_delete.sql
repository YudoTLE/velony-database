DROP TRIGGER trg_messages_rechain ON public.messages;

CREATE TRIGGER trg_messages_rechain
AFTER DELETE ON public.messages
FOR EACH ROW
EXECUTE FUNCTION public.rechain_messages();
