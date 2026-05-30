# Step 1: Verstehen von Usern und Gruppen

## Core Concepts

### What is a User?

A **user** (or account) on Linux can run programs and own files. Each user has:

- **Username**: A unique login name (e.g., `john`, `sarah`)
- **UID (User ID)**: A unique numeric identifier (e.g., 1000, 1001)
- **Primary Group**: One group assigned to the user
- **Home Directory**: Default location when user logs in (e.g., `/home/john`)
- **Login Shell**: Shell used when user logs in (e.g., `/bin/bash`)

### What is a Group?

A **group** is a collection of users that share permissions on files and directories. Each group has:

- **Group Name**: Unique identifier (e.g., `developers`, `accounting`)
- **GID (Group ID)**: Unique numeric identifier (e.g., 1000, 1001)
- **Members**: Users belonging to the group

## User and Group Relationships

### Primary Group
- Every user belongs to exactly ONE primary group
- Determined when the user is created
- Stored in `/etc/passwd` (field 4)
- New files created by the user belong to this group by default

### Secondary Groups
- A user can belong to ZERO or more secondary groups
- Provides access to shared group resources
- Stored in `/etc/group` (last field)
- Can be modified with `usermod -a -G`

## Why Groups Matter?

Groups allow:
- **Shared Access**: Multiple users can access the same files/directories
- **Project Organization**: Group files by project team
- **Permission Management**: Grant permissions to groups instead of individuals

## Check Current System Users and Groups

Let's look at the system users and groups on this machine:

```bash
# View system users (first 10 lines)
head /etc/passwd
```

```bash
# View system groups
head /etc/group
```

```bash
# Show your current user
whoami
```

```bash
# Show all groups for current user
groups
```

## Key Takeaways

✓ Users have unique usernames and UIDs  
✓ Each user belongs to at least one primary group  
✓ Users can be members of multiple secondary groups  
✓ Groups enable permission management and collaboration

Ready to explore the configuration files? Click **Next** to continue!
