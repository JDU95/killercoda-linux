# Step 2: System Configuration Files

## The Four Key Files

Linux stores user and group information in four important files. Let's examine each one:

### 1. /etc/passwd - User Account Information

This file contains basic user information (except passwords). Each line has 7 fields separated by colons:

```
username:x:UID:GID:comment:home-directory:login-shell
```

**Example:**
```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
john:x:1000:1000:John Doe:/home/john:/bin/bash
```

**Field Breakdown:**
1. **username** - Login name
2. **x** - Password hash (now stored in /etc/shadow)
3. **UID** - User ID (0 = root)
4. **GID** - Primary group ID
5. **comment** - Full name/description
6. **home-directory** - User's home directory path
7. **login-shell** - Shell program executed at login

**Permissions:** Readable by all, writable only by root

### 2. /etc/shadow - Password and Aging Data

Contains encrypted passwords and password aging information. **Only root can read this file!**

Each line has 9 fields:
```
username:password-hash:changed:minlife:maxlife:warn:inactive:expire:unused
```

**Aging Parameters:**
- **changed** - Days since Jan 1, 1970 when password was last changed
- **minlife** - Minimum days before password can be changed (0 = no limit)
- **maxlife** - Maximum days until password must be changed (9999 = no limit)
- **warn** - Days warning given before password expiration
- **inactive** - Days after expiration before account is disabled
- **expire** - Account expiration date (empty = no limit)

### 3. /etc/group - Group Information

Contains group definitions. Each line has 4 fields:

```
groupname:x:GID:additional-users
```

**Example:**
```
root:x:0:
developers:x:1001:john,sarah,mike
accounting:x:1002:alice,bob
```

**Field Breakdown:**
1. **groupname** - Group name
2. **x** - Group password (rarely used)
3. **GID** - Group ID
4. **additional-users** - Secondary group members (comma-separated)

### 4. /etc/gshadow - Group Passwords (rarely used)

Contains encrypted group passwords. Similar structure to /etc/shadow but for groups.

## Examine the Files

Let's look at these files on your system:

```bash
# View /etc/passwd
cat /etc/passwd | head -15
```

```bash
# View /etc/group
cat /etc/group | head -15
```

```bash
# Check file permissions (important for security!)
ls -l /etc/passwd /etc/shadow /etc/group /etc/gshadow
```

**Security Note:** Notice that only root can read `/etc/shadow`. This protects password hashes from unauthorized access!

## Examine Your User

Find your own user entry:

```bash
# Get current username
MYUSER=$(whoami)
echo "Looking for user: $MYUSER"

# Find your line in /etc/passwd
grep "^$MYUSER:" /etc/passwd

# Find your groups in /etc/group
grep "$MYUSER" /etc/group
```

## Key Takeaways

✓ `/etc/passwd` - User account info (readable by all)  
✓ `/etc/shadow` - Encrypted passwords (root only!)  
✓ `/etc/group` - Group definitions and members  
✓ `/etc/gshadow` - Group passwords (rarely used)  
✓ These files must be carefully protected for system security

Ready to create your first user? Let's move on!
