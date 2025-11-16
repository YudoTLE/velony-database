BEGIN;

-- Step 1: Delete duplicate unverified records, keeping only the latest one
DELETE FROM public.verifications v
USING (
    SELECT user_id, type, MAX(initiated_at) AS latest_initiated_at
    FROM public.verifications
    WHERE verified_at IS NULL
    GROUP BY user_id, type
    HAVING COUNT(*) > 1
) dups
WHERE v.verified_at IS NULL
  AND v.user_id = dups.user_id
  AND v.type = dups.type
  AND v.initiated_at < dups.latest_initiated_at;

-- Optional fallback (in case same initiated_at)
DELETE FROM public.verifications v
USING (
    SELECT user_id, type, MAX(id) AS latest_id
    FROM public.verifications
    WHERE verified_at IS NULL
    GROUP BY user_id, type
    HAVING COUNT(*) > 1
) dups
WHERE v.verified_at IS NULL
  AND v.user_id = dups.user_id
  AND v.type = dups.type
  AND v.id < dups.latest_id;

-- Step 2: Create the unique index (transaction-safe)
CREATE UNIQUE INDEX verifications_user_type_unverified_unique
ON public.verifications (user_id, type)
WHERE verified_at IS NULL;

COMMIT;
