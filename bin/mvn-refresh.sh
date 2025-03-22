#!/bin/bash

echo "🚀 Running Maven Cleanup, Dependency Refresh, and Tests..."

# Step 1: Clean the project (removes old compiled files)
mvn clean

# Step 2: Compile the project (rebuilds everything)
mvn compile

# Step 3: Purge old dependencies and redownload them
mvn dependency:purge-local-repository

# Step 4: Run tests
mvn test

echo "✅ Done! Maven project refreshed and tests executed."

