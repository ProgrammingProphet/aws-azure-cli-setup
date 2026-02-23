#!/bin/bash

# ===============================
# DEVOPS ENVIRONMENT VALIDATION
# ===============================

# ----- Colors -----
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

echo -e "${BLUE}=========================================${RESET}"
echo -e "${BLUE}   DEVOPS ENVIRONMENT VALIDATION 🚀     ${RESET}"
echo -e "${BLUE}=========================================${RESET}"
echo ""

# ------------------------------
# System Information
# ------------------------------
echo -e "${YELLOW}📌 SYSTEM INFORMATION${RESET}"
echo "-----------------------------------------"
echo "Hostname      : $(hostname)"
echo "OS            : $(lsb_release -d 2>/dev/null | cut -f2)"
echo "Kernel        : $(uname -r)"
echo "Architecture  : $(uname -m)"
echo "Uptime        : $(uptime -p)"
echo ""

echo "CPU           : $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
echo "Memory        : $(free -h | awk '/Mem:/ {print $2 " total, " $3 " used"}')"
echo ""

# ------------------------------
# Tool Check Function
# ------------------------------
check_tool() {
    TOOL_NAME=$1
    VERSION_COMMAND=$2

    if command -v $TOOL_NAME >/dev/null 2>&1; then
        VERSION=$($VERSION_COMMAND 2>/dev/null | head -n 1)
        echo -e "${GREEN}✅ $TOOL_NAME installed:${RESET} $VERSION"
    else
        echo -e "${RED}❌ $TOOL_NAME NOT installed${RESET}"
    fi
}

echo -e "${YELLOW}📦 DEVOPS TOOLCHAIN CHECK${RESET}"
echo "-----------------------------------------"

check_tool "git" "git --version"
check_tool "docker" "docker --version"
check_tool "terraform" "terraform --version"
check_tool "ansible" "ansible --version"
check_tool "kind" "kind --version"
check_tool "kubectl" "kubectl version --client"
check_tool "aws" "aws --version"
check_tool "az" "az --version"
check_tool "python3" "python3 --version"
check_tool "java" "java --version"

echo ""

# ------------------------------
# Docker Service Check
# ------------------------------
if command -v docker >/dev/null 2>&1; then
    if docker info >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Docker service is running${RESET}"
    else
        echo -e "${RED}❌ Docker installed but NOT running${RESET}"
    fi
fi

# ------------------------------
# AWS Authentication Check
# ------------------------------
if command -v aws >/dev/null 2>&1; then
    if aws sts get-caller-identity >/dev/null 2>&1; then
        echo -e "${GREEN}✅ AWS CLI authenticated${RESET}"
    else
        echo -e "${YELLOW}⚠️ AWS CLI installed but NOT authenticated${RESET}"
    fi
fi

# ------------------------------
# Azure Authentication Check
# ------------------------------
if command -v az >/dev/null 2>&1; then
    if az account show >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Azure CLI authenticated${RESET}"
    else
        echo -e "${YELLOW}⚠️ Azure CLI installed but NOT authenticated${RESET}"
    fi
fi

echo ""
echo -e "${BLUE}=========================================${RESET}"
echo -e "${BLUE}   CHECK COMPLETE ✔                     ${RESET}"
echo -e "${BLUE}=========================================${RESET}"
