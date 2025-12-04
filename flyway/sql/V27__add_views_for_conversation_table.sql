BEGIN;

CREATE OR REPLACE VIEW conversations_active AS
SELECT 
    id,
    uuid,
    title,
    description,
    thumbnail_url
    created_at,
    updated_at
FROM public.conversations
WHERE deleted_at IS NULL;

CREATE OR REPLACE VIEW conversations_deleted AS
SELECT 
    id,
    uuid,
    title,
    description,
    thumbnail_url
    created_at,
    updated_at,
    deleted_at
FROM public.conversations
WHERE deleted_at IS NOT NULL;

COMMIT;