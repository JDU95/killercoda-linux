# Step 3: Creating Users with useradd

## The useradd Command

The **useradd** command is the standard way to create new user accounts. It automatically:
- Adds an entry to `/etc/passwd`
- Creates the user's home directory
- Copies skeleton configuration files
- Sets up proper permissions

### Basic Usage

```bash
# Create a user with default settings
sudo useradd username

# Or with a comment (full name)
sudo useradd -c "Full Name" username
```

### Useful Options

```
-c "comment"      Full name or description
-d /home/dir      Specify home directory (default: /home/username)
-g groupname      Primary group (default: new group with same name)
-G group1,group2  Secondary groups (comma-separated)
-s /bin/shell     Login shell (default: /bin/bash)
-u UID           Specific UID (default: next available)
-e YYYY-MM-DD    Account expiration date
-m               Create home directory (usually default)
```

## Example: Create Your First User

Let's create a user named `alice`:

```bash
# Create basic user named alice
sudo useradd -c "Alice Smith" -s /bin/bash alice
```

Verify it was created:

```bash
# Check /etc/passwd entry
grep "^alice:" /etc/passwd

# Verify home directory exists
ls -la /home/alice
```

## Create User with Primary Group

Let's create a user with a specific primary group:

```bash
# First, create a group (we'll learn this in detail later)
sudo groupadd developers

# Create user with developers as primary group
sudo useradd -c "Bob Johnson" -g developers -s /bin/bash bob
```

Verify:

```bash
grep "^bob:" /etc/passwd
grep "^developers:" /etc/group
```

## Create User with Secondary Groups

Create a user belonging to multiple groups:

```bash
# Create additional groups
sudo groupadd admins
sudo groupadd testing

# Create user with secondary groups
sudo useradd -c "Charlie Davis" -g developers -G admins,testing -s /bin/bash charlie
```

Verify:

```bash
# Check /etc/passwd
grep "^charlie:" /etc/passwd

# Check all groups
groups charlie
```

## Viewing User Information

```bash
# Show all users (including system users)
cut -d: -f1 /etc/passwd

# Count total users
wc -l /etc/passwd

# Show users with home in /home directory
cat /etc/passwd | grep "^[^:]*:[^:]*:[0-9]*:[0-9]*:[^:]*:/home/"
```

## Important Notes

⚠️ **Password Required**: `useradd` doesn't set a password! You must use `passwd` (next step)

⚠️ **Default Shell**: Verify the shell exists in `/etc/shells`:
```bash
cat /etc/shells
```

⚠️ **Home Directory**: Created from `/etc/skel` template:
```bash
ls -la /etc/skel
```

## Practice

Try creating these users:

1. **User**: `david` with comment `"David Wilson"`, primary group `developers`
2. **User**: `emma` with groups: primary `developers`, secondary `admins,testing`

```bash
# Create your practice users here:
sudo useradd -c "David Wilson" -g developers -s /bin/bash david
sudo useradd -c "Emma Brown" -g developers -G admins,testing -s /bin/bash emma

# Verify both users exist
grep -E "^(david|emma):" /etc/passwd
```

Ready to set passwords? Let's continue!
