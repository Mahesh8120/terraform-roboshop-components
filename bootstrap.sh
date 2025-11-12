#!/bin/bash
component=$1
environment=$2

dnf install ansible -y

REPO_URL=https://github.com/Mahesh8120/Ansible_Roboshop-roles-tf.git
REPO_DIR=/opt/roboshop/ansible
ANSIBLE_DIR=ansible-roboshop-roles-tf
ANSIBLE_PATH=$REPO_DIR/$ANSIBLE_DIR

mkdir -p $REPO_DIR
mkdir -p /var/log/roboshop/
touch /var/log/roboshop/ansible.log

cd $REPO_DIR

# Check if repo already exists
if [ -d "$ANSIBLE_DIR" ]; then
    echo "Updating existing repo..."
    cd "$ANSIBLE_DIR"
    git pull
else
    echo "Cloning repo..."
    git clone $REPO_URL .
    # Note: '.' clones into current directory ($REPO_DIR)
fi

# Now we are in $REPO_DIR/ansible-roboshop-roles-tf
echo "environment is: $environment"

# Verify main.yaml exists
if [ ! -f "main.yaml" ]; then
    echo "ERROR: main.yaml not found in $(pwd)" >&2
    ls -la
    exit 1
fi

# Run playbook
ansible-playbook -e component=$component -e env=$environment main.yaml