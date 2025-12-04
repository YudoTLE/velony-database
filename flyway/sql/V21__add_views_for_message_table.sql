BEGIN;

CREATE OR REPLACE VIEW messages_active AS
SELECT 
    id,
    uuid,
    user_id,
    conversation_id,
    content,
    created_at,
    updated_at,
    previous_id,
    user_uuid,
    conversation_uuid,
    previous_uuid
FROM public.messages
WHERE deleted_at IS NULL;

CREATE OR REPLACE VIEW messages_deleted AS
SELECT 
    id,
    uuid,
    user_id,
    conversation_id,
    content,
    created_at,
    updated_at,
    previous_id,
    user_uuid,
    conversation_uuid,
    previous_uuid,
    deleted_at
FROM public.messages
WHERE deleted_at IS NOT NULL;

COMMIT;