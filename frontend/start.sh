#!/bin/bash
set -e

# Export frontend env variables dynamically
export $(grep -v '^#' /app/frontend/.env | xargs)

# Start React dev server
npm start
