DROP VIEW IF EXISTS
    public.users_active,
    public.users_deleted,
    public.conversations_active,
    public.conversations_deleted,
    public.user_conversations_active,
    public.user_conversations_deleted,
    public.messages_active,
    public.messages_deleted
    CASCADE;