CREATE TABLE public.verifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    type VARCHAR(15) NOT NULL,
    value VARCHAR(255) NOT NULL,
    code VARCHAR(255) NOT NULL,
    verified_at TIMESTAMP,
    initiated_at TIMESTAMP DEFAULT now(),
    expires_at TIMESTAMP NOT NULL
);

CREATE INDEX idx_verifications_user_id ON public.verifications(user_id);

CREATE INDEX idx_verifications_code ON public.verifications(code);

CREATE INDEX idx_verifications_user_type_expires ON public.verifications(user_id, type, expires_at);

CREATE INDEX idx_verifications_expires_at ON public.verifications(expires_at);
