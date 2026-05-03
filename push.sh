#!/bin/bash

echo "===== PUSH CODE TO GITHUB ====="

# 1. Init git
git init

# 2. Add all files
git add .

# 3. Commit
git commit -m "Initial commit - Sports Ticketing System"

# 4. Set branch
git branch -M main

# 5. Add remote (CHANGE THIS LINK)
git remote remove origin 2>/dev/null
git remote add origin https://github.com/chelsea29290lab/https-github.com-yourname-sports-ticketing-system.git

# 6. Push
git push -u origin main

echo "===== DONE PUSHING TO GITHUB ====="