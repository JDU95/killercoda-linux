# Step 5: Managing Groups

## Group Management Commands

### Create Groups with groupadd

```bash
sudo groupadd groupname
sudo groupadd -g GID groupname        # Specify specific GID
```

### Modify Groups with groupmod

```bash
sudo groupmod -n newname oldname      # Rename group
sudo groupmod -g newGID groupname     # Change GID
```

### Delete Groups with groupdel

```bash
sudo groupdel groupname               # Delete group (not allowed if it's user's primary group)
```

### Add Users to Groups

```bash
# Add user to secondary group
sudo usermod -a -G groupname username

# Add user to multiple secondary groups
sudo usermod -a -G group1,group2 username

# Change primary group
sudo usermod -g newgroup username
```

## Practical Examples

### Create Project Groups

Let's create groups for different projects:

```bash
# Create groups
sudo groupadd webdev
sudo groupadd backend
sudo groupadd devops

# Verify groups were created
grep -E "^(webdev|backend|devops):" /etc/group
```

### Add Users to Groups

```bash
# Ensure we have some users
sudo useradd -c "Alice Dev" alice 2>/dev/null
sudo useradd -c "Bob Dev" bob 2>/dev/null
sudo useradd -c "Charlie Dev" charlie 2>/dev/null

# Add alice to webdev group
sudo usermod -a -G webdev alice

# Add bob to backend and devops
sudo usermod -a -G backend,devops bob

# Add charlie to all project groups
sudo usermod -a -G webdev,backend,devops charlie

# Verify group memberships
echo "=== Group memberships ==="
groups alice
groups bob
groups charlie
```

### Check Group Contents

```bash
# Show all members of a group
grep "^webdev:" /etc/group

# List all groups for a user
id alice

# Show user's primary and secondary groups
groups charlie
```

### Create Shared Project Directory

Create a directory where team members can collaborate:

```bash
# Create project directory
sudo mkdir -p /projects/webdev

# Set group ownership to webdev
sudo chown :webdev /projects/webdev

# Set permissions: owner full, group read/write/execute
sudo chmod 770 /projects/webdev

# Verify
ls -ld /projects/webdev

# Test: user in group can create files
sudo -u alice touch /projects/webdev/test.txt
ls -l /projects/webdev/test.txt
```

## Understanding Primary vs Secondary Groups

### Primary Group

- Set when user is created
- In `/etc/passwd` field 4
- Files created belong to this group by default
- Cannot be removed

```bash
# Check alice's primary group
grep "^alice:" /etc/passwd | cut -d: -f4

# Get GID to name mapping
getent group $(grep "^alice:" /etc/passwd | cut -d: -f4)
```

### Secondary Groups

- Added with `usermod -a -G`
- Listed in `/etc/group` last field
- User can switch between secondary groups
- Can be removed

```bash
# Show alice's all groups (primary + secondary)
groups alice

# Show alice's numeric group IDs
id alice
```

### Switch Between Secondary Groups

```bash
# Show current group context
id alice

# Switch to webdev group (if alice is a member)
# Note: this typically requires being the user or using su/sudo
sudo su - alice -c "newgrp webdev && id && touch /projects/webdev/myfile.txt"
```

## Best Practices

✓ **Use meaningful group names**: `developers`, `accounting`, not `g1`, `g2`

✓ **Organize by project or function**: Create groups for logical team structures

✓ **Use `-a` flag**: Always use `usermod -a -G` (append) not `-G` (replace)

✓ **Verify changes**: Always verify groups with `grep`, `groups`, or `id`

✓ **Document**: Keep track of what each group is for

## Practice Exercises

Complete these tasks:

1. **Create a team structure**:
   ```bash
   # Create groups for different departments
   sudo groupadd frontend
   sudo groupadd database
   sudo groupadd infrastructure
   
   # Create users for each department
   sudo useradd -c "Frontend Dev" dev_frontend
   sudo useradd -c "Database Admin" db_admin
   sudo useradd -c "DevOps Engineer" devops_eng
   
   # Assign to groups
   sudo usermod -a -G frontend dev_frontend
   sudo usermod -a -G database db_admin
   sudo usermod -a -G infrastructure devops_eng
   
   # Verify
   echo "Frontend group:" && grep "^frontend:" /etc/group
   echo "Database group:" && grep "^database:" /etc/group
   echo "Infrastructure group:" && grep "^infrastructure:" /etc/group
   ```

2. **Create shared resources**:
   ```bash
   # Create shared directories
   sudo mkdir -p /share/frontend
   sudo mkdir -p /share/database
   
   # Set group ownership
   sudo chown :frontend /share/frontend
   sudo chown :database /share/database
   
   # Set permissions
   sudo chmod 770 /share/frontend
   sudo chmod 770 /share/database
   
   # Verify
   ls -ld /share/{frontend,database}
   ```

Ready to tackle a real-world exercise? Let's continue!
