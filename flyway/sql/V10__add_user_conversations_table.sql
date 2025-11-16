CREATE TABLE public.user_conversations (
    user_id INTEGER NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    conversation_id INTEGER NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    role VARCHAR(15) NOT NULL,
    created_at TIMESTAMP DEFAULT now(),

    PRIMARY KEY (user_id, conversation_id)
);

CREATE INDEX idx_user_conversations_conversation_id
ON user_conversations(conversation_id);
