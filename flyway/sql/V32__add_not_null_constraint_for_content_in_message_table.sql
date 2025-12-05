BEGIN;

UPDATE messages
SET content = ''
WHERE content IS NULL;

ALTER TABLE messages
ALTER COLUMN content SET NOT NULL;

COMMIT;
