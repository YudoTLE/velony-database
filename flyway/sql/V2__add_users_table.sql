CREATE TABLE public.users (
    id serial PRIMARY KEY,
    uuid uuid DEFAULT gen_random_uuid () NOT NULL UNIQUE,
    name varchar(50) NOT NULL,
    username varchar(50) NOT NULL UNIQUE,
    email varchar(100) UNIQUE,
    password_hash text,
    phone_number varchar(20),
    profile_picture_url text,
    created_at timestamp DEFAULT now(),
    updated_at timestamp DEFAULT now()
);

CREATE OR REPLACE FUNCTION public.set_updated_at ()
    RETURNS TRIGGER
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trg_users_set_updated_at
    BEFORE UPDATE ON public.users
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at ();