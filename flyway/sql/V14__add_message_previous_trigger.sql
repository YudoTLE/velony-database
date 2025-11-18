
CREATE OR REPLACE FUNCTION set_previous_message()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.previous_id IS NULL THEN
    SELECT id INTO NEW.previous_id
    FROM messages
    WHERE conversation_id = NEW.conversation_id
    ORDER BY id DESC
    LIMIT 1;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_previous_message
BEFORE INSERT ON messages
FOR EACH ROW
EXECUTE FUNCTION set_previous_message();
