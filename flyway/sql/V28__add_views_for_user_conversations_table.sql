BEGIN;

CREATE OR REPLACE VIEW user_conversations_active AS
SELECT 
    id,
    uuid,
    user_id,
    conversation_id,
    role,
    created_at,
    updated_at
FROM public.user_conversations
WHERE deleted_at IS NULL;

CREATE OR REPLACE VIEW user_conversations_deleted AS
SELECT 
    id,
    uuid,
    user_id,
    conversation_id,
    role,
    created_at,
    updated_at,
    deleted_at
FROM public.user_conversations
WHERE deleted_at IS NOT NULL;

COMMIT;