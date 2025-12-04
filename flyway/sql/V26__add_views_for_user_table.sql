BEGIN;

CREATE OR REPLACE VIEW users_active AS
SELECT 
    id,
    uuid,
    name,
    username,
    avatar_url
    email,
    password_hash,
    phone_number,
    created_at,
    updated_at
FROM public.users
WHERE deleted_at IS NULL;

CREATE OR REPLACE VIEW users_deleted AS
SELECT 
    id,
    uuid,
    name,
    username,
    avatar_url
    email,
    password_hash,
    phone_number,
    created_at,
    updated_at,
    deleted_at
FROM public.users
WHERE deleted_at IS NOT NULL;

COMMIT;