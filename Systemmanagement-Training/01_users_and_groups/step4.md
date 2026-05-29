# Step 4: Managing User Passwords

## Setting Passwords with passwd

The **passwd** command is used to set or change passwords. 

### Basic Usage

```bash
# Change your own password (interactive)
passwd

# Set password for another user (root only)
sudo passwd username

# Set password non-interactively (for scripts)
echo "newpassword" | sudo passwd --stdin username
```

## Password Aging with chage

The **chage** command manages password aging policies. This forces users to change passwords periodically and improves security.

### Common Options

```
-l username              List current settings
-d 0 username            Force password change at next login
-M days username         Password must be changed every N days
-W days username         Warn N days before expiration
-i days username         Account disabled N days after expiration
-E YYYY-MM-DD username   Set account expiration date
```

## Practical Examples

### Set Initial Password

Let's set a password for alice:

```bash
# Set password for alice (will prompt for input)
sudo passwd alice
# Enter: alice123 (for demo purposes)
```

Verify in `/etc/shadow`:

```bash
# Show alice's shadow entry (password hash)
sudo grep "^alice:" /etc/shadow
```

### Force Password Change at First Login

Set up bob to change password on first login:

```bash
# Create bob if not already created
sudo useradd -c "Bob Johnson" -g developers bob 2>/dev/null

# Set initial password
echo "temppass" | sudo passwd --stdin bob

# Force password change on next login
sudo chage -d 0 bob
```

Verify:

```bash
# Check bob's aging settings
sudo chage -l bob
```

### Set Password Expiration Policy

Create a user with strict password policy:

```bash
# Create user
sudo useradd -c "Sarah Miller" -g developers sarah

# Set password
echo "password123" | sudo passwd --stdin sarah

# Policy: Change password every 90 days, warn 7 days before expiration
sudo chage -M 90 -W 7 sarah

# Show the policy
sudo chage -l sarah
```

### Set Account Expiration

Create a temporary project account that expires:

```bash
# Create temporary user
sudo useradd -c "Temp Contractor" -g developers temp_contractor

# Set password
echo "temp123" | sudo passwd --stdin temp_contractor

# Account expires in 30 days
EXPIRY=$(date -d "+30 days" +%Y-%m-%d)
sudo chage -E "$EXPIRY" temp_contractor

# Verify
sudo chage -l temp_contractor
```

## Understanding /etc/shadow

View the shadow file to understand password aging:

```bash
# Show shadow format (only root can read this!)
sudo cat /etc/shadow | head -5

# Parse shadow file - format:
# username:password-hash:last-change:min-days:max-days:warning:inactive:expire:reserved

# Example fields explained:
sudo awk -F: '{if (NR <= 3) print "Username: "$1" | Last changed: "$3" | Max days: "$5}' /etc/shadow
```

## Security Considerations

⚠️ **Strong Passwords**: Users should have strong passwords (use `pwgen` or similar):

```bash
# Generate strong password suggestions
echo "Password suggestions:"
echo "$(openssl rand -base64 12)"
echo "$(openssl rand -base64 12)"
```

⚠️ **Password History**: Check password requirements:

```bash
# View password requirements
sudo cat /etc/login.defs | grep -E "^PASS"
```

## Practice Exercises

Complete these tasks:

1. **Lock a user account**:
   ```bash
   sudo passwd -l alice
   # User can't login, but account isn't deleted
   
   # Unlock:
   sudo passwd -u alice
   ```

2. **Create expiring test account**:
   ```bash
   sudo useradd -c "Test User" testuser
   echo "testpass123" | sudo passwd --stdin testuser
   sudo chage -M 30 -W 7 -i 7 testuser
   sudo chage -l testuser
   ```

3. **Check all users and their expiration**:
   ```bash
   sudo awk -F: '{if ($5 != 9999 && $5 != "" && $5 > 0) print $1" - Max days: "$5}' /etc/shadow
   ```

Ready to manage groups? Let's continue!
