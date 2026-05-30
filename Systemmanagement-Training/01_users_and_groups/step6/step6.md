# Step 6: Exercise - Create Project Users

## Scenario

You're the system administrator for a software company with two projects:

### Project: Bank Heist
Team members: Joe Dalton, Jack Dalton, William Dalton
Project directory: `/projects/bank`

### Project: Train Robbery
Team members: Joe Dalton, Averall Dalton
Project directory: `/projects/train`

**Requirements:**
- Each user has their own home directory
- Users have access to their project directories
- Password must be changed every 30 days
- Accounts must expire after 90 days

## Let's Build It!

### Step 1: Create Groups

```bash
# Create project groups
sudo groupadd bank
sudo groupadd train

echo "Groups created:"
grep -E "^(bank|train):" /etc/group
```

### Step 2: Create Users

```bash
# Bank project users
sudo useradd -c "Joe Dalton" joe
sudo useradd -c "Jack Dalton" jack
sudo useradd -c "William Dalton" william

# Train project users (averall is additional to joe)
sudo useradd -c "Averall Dalton" averall

# Verify users created
echo "Users created:"
grep -E "^(joe|jack|william|averall):" /etc/passwd | cut -d: -f1
```

### Step 3: Set Passwords

```bash
# Generate secure passwords
echo "Setting passwords..."
echo "temppass123" | sudo passwd --stdin joe
echo "temppass123" | sudo passwd --stdin jack
echo "temppass123" | sudo passwd --stdin william
echo "temppass123" | sudo passwd --stdin averall

# Force password change on first login
sudo chage -d 0 joe
sudo chage -d 0 jack
sudo chage -d 0 william
sudo chage -d 0 averall

echo "Passwords set - users must change on first login"
```

### Step 4: Configure Password Policies

```bash
# Max password age: 30 days, warn 7 days before, inactive after 7 days
# Account expires: 90 days from now

EXPIRY=$(date -d "+90 days" +%Y-%m-%d)

for user in joe jack william averall; do
  # Password policy
  sudo chage -M 30 -W 7 -i 7 "$user"
  # Account expiration
  sudo chage -E "$EXPIRY" "$user"
done

# Show policies
echo "=== Joe's policy ==="
sudo chage -l joe

echo ""
echo "=== Averall's policy ==="
sudo chage -l averall
```

### Step 5: Assign to Groups

```bash
# Joe belongs to both projects
sudo usermod -a -G bank joe
sudo usermod -a -G train joe

# Jack and William in bank only
sudo usermod -a -G bank jack
sudo usermod -a -G bank william

# Averall in train only
sudo usermod -a -G train averall

# Verify group assignments
echo "=== Group Assignments ==="
echo "Bank group members:" && grep "^bank:" /etc/group
echo "Train group members:" && grep "^train:" /etc/group
```

### Step 6: Create and Configure Project Directories

```bash
# Create project directories
sudo mkdir -p /projects/bank
sudo mkdir -p /projects/train

# Set group ownership
sudo chown :bank /projects/bank
sudo chown :train /projects/train

# Set permissions: owner full, group read/write/execute, others nothing
sudo chmod 770 /projects/bank
sudo chmod 770 /projects/train

# Verify
echo "=== Project Directories ==="
ls -ld /projects/{bank,train}
```

### Step 7: Verify Everything

```bash
# Check all users exist with home directories
echo "=== Users and Homes ==="
for user in joe jack william averall; do
  echo -n "$user: "
  grep "^$user:" /etc/passwd | cut -d: -f1,3,6
done

echo ""
echo "=== Group Memberships ==="
for user in joe jack william averall; do
  echo "$user: $(groups $user | cut -d: -f2)"
done

echo ""
echo "=== Password Policies (Joe and Averall) ==="
echo "Joe:" && sudo chage -l joe | grep -E "Password expires|Account expires"
echo "Averall:" && sudo chage -l averall | grep -E "Password expires|Account expires"

echo ""
echo "=== Project Directory Permissions ==="
ls -ld /projects/{bank,train}
```

## Test User Access

Let's verify users can access their project directories:

```bash
# Create test files as each user
sudo -u joe touch /projects/bank/joe_file.txt
sudo -u jack touch /projects/bank/jack_file.txt
sudo -u joe touch /projects/train/joe_train.txt
sudo -u averall touch /projects/train/averall_train.txt

echo "=== Files Created ==="
ls -l /projects/bank/
echo ""
ls -l /projects/train/
```

## Troubleshooting

If you made mistakes, here's how to fix them:

```bash
# Remove a user from a group
sudo usermod -G "" joe  # Removes all secondary groups (careful!)

# Or better: remove specific group
sudo gpasswd -d joe bank  # Remove joe from bank group

# Delete a user (optional cleanup)
sudo userdel -r username  # -r also removes home directory

# Delete a group
sudo groupdel groupname
```

## Summary

You've successfully:
✓ Created two project groups (bank, train)  
✓ Created four users with home directories  
✓ Set password policies (30-day expiration, warnings)  
✓ Set account expiration (90 days)  
✓ Organized users into project groups  
✓ Created shared project directories with proper permissions  

Ready to learn about administrative access? Continue to the next step!
