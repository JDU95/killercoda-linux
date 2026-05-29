# Step 7: sudo and Administrative Access

## The Problem with Shared root Password

- Multiple admins sharing the root password is **insecure**
- No audit trail of who did what
- Lost password → emergency recovery
- Compromised password → complete system breach

## The Solution: sudo

The **sudo** command allows regular users to execute commands as root (or other users) **without sharing the root password**.

### How sudo Works

```bash
# Regular user runs command with sudo
user@host$ sudo command

# System checks /etc/sudoers for permissions
# If allowed, command runs as root
# Authenticates with user's password, not root password
```

### Basic Usage

```bash
# Run single command as root
sudo command

# Run command as different user
sudo -u username command

# Open root shell (everything after runs as root)
sudo -s
# Type 'exit' to return to normal user

# Run shell as specific user
sudo -i -u username
```

## The /etc/sudoers File

This file controls who can use sudo and what commands they can run.

### Important Rules

⚠️ **ALWAYS edit with `visudo`**, not a regular text editor!
- Validates syntax
- Prevents file corruption
- Prevents being locked out

```bash
# Edit sudoers file safely
sudo visudo
```

### Sudoers Syntax

General format:
```
user  host = (runas_user) command
```

**Examples:**

```
# Allow joe to run any command as root
joe ALL=(ALL) ALL

# Allow admin group to run any command
%admin ALL=(ALL) ALL

# Allow users to restart apache without password
developers ALL=(ALL) NOPASSWD: /etc/init.d/apache2 restart

# Allow specific commands only
operator ALL=(ALL) /sbin/reboot, /sbin/shutdown
```

## Field Breakdown

- **User/Group**: `username` or `%groupname`
- **Host**: `ALL` (works on any host) or specific hostname
- **Run As**: `(ALL)` (as anyone) or `(root)` or `(user1,user2)`
- **Commands**: `ALL` (any command) or specific commands with full path

## Practical Examples

### Allow User Administrative Privileges

```bash
# Add joe to sudoers for full administrative access
echo "joe ALL=(ALL) ALL" | sudo tee -a /etc/sudoers.d/joe

# Verify
sudo cat /etc/sudoers.d/joe

# Test: joe can now run sudo commands
sudo -u joe sudo whoami  # Should output: root
```

### Allow Group to Run Specific Commands

```bash
# Create admin rule for bank group
sudo bash -c 'echo "%bank ALL=(ALL) ALL" > /etc/sudoers.d/bank_admins'

# Verify
sudo cat /etc/sudoers.d/bank_admins

# This allows all bank group members to use sudo
```

### Allow Commands Without Password

```bash
# Allow members of admin group to use sudo without password
echo "%admin ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/admin_nopass

# WARNING: This is less secure but useful for scripts
```

### Allow Specific Commands Only

```bash
# Let developers restart web server without full sudo access
sudo bash -c 'echo "developers ALL=(ALL) NOPASSWD: /usr/sbin/systemctl restart apache2" > /etc/sudoers.d/developers_apache'

# Users in 'developers' group can only restart apache, not get root shell
sudo -u alice sudo systemctl restart apache2  # Works if alice is in developers group
sudo -u alice sudo whoami  # Won't work - command not allowed
```

## Practical Setup for Our Project

Let's set up sudo for our Dalton project teams:

```bash
# Make bank group members administrators
sudo bash -c 'echo "%bank ALL=(ALL) ALL" > /etc/sudoers.d/bank_admins'

# Make train group members able to manage services
sudo bash -c 'echo "%train ALL=(ALL) NOPASSWD: /usr/sbin/systemctl" > /etc/sudoers.d/train_services'

# Verify rules
echo "=== Bank Admins ===" && sudo cat /etc/sudoers.d/bank_admins
echo "=== Train Services ===" && sudo cat /etc/sudoers.d/train_services
```

## Checking Sudo Permissions

```bash
# List what sudo can do
sudo -l

# List what specific user can do
sudo -l -U joe

# Check if user can run specific command without password
sudo -l -U joe -p /usr/sbin/systemctl
```

## Sudo Log

Sudo actions are logged for security auditing:

```bash
# View sudo log
sudo grep sudo /var/log/auth.log | tail -10

# Or check sudo specific log (if configured)
sudo tail /var/log/sudo.log 2>/dev/null
```

## Security Best Practices

✓ **Always use visudo** - Never edit `/etc/sudoers` directly

✓ **Use groups** - Easier to manage than individual users

✓ **Principle of least privilege** - Only grant needed permissions

✓ **Specific commands** - Better than `ALL` when possible

✓ **No passwords** - Only for trusted automation

✓ **Monitor logs** - Regularly check sudo usage

✓ **Keep sudoers simple** - Easy rules are easier to audit

## Practice: Set Up Sudoers

Complete this exercise:

```bash
# 1. Create or verify you have the admin group
sudo groupadd admin 2>/dev/null

# 2. Add user to admin group
sudo useradd testadmin 2>/dev/null
sudo usermod -a -G admin testadmin

# 3. Configure sudo for admin group
sudo bash -c 'echo "%admin ALL=(ALL) ALL" > /etc/sudoers.d/admin'

# 4. Verify it works
echo "Admin group sudoers rule:"
sudo cat /etc/sudoers.d/admin

# 5. Check syntax
sudo visudo -c  # Returns "parse error" message if errors
```

## Comparison: User vs Root

```bash
# Without sudo - access denied
ssh testadmin "cat /etc/shadow"  # Permission denied

# With sudo - works
ssh testadmin "sudo cat /etc/shadow"  # Succeeds if sudoer
```

## Cleaning Up Sudoers Files

```bash
# List all sudoers rules
sudo ls -la /etc/sudoers.d/

# Remove specific rule
sudo rm /etc/sudoers.d/bank_admins

# Check remaining rules
sudo cat /etc/sudoers.d/*
```

Excellent! You've completed the Linux Users and Groups scenario! Let's wrap up and review what you've learned.
