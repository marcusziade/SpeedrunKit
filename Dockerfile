# Build stage
FROM swift:6.1-jammy AS builder

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package files
COPY Package.* ./

# Resolve dependencies
RUN swift package resolve

# Copy source code
COPY . .

# Build the project
RUN swift build -c release

# Run tests
RUN swift test

# Runtime stage
FROM swift:6.1-jammy-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libcurl4 \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -u 1000 speedrun

# Set working directory
WORKDIR /app

# Copy built executable
COPY --from=builder /app/.build/release/speedrun-cli /usr/local/bin/speedrun-cli

# Copy library artifacts for potential use
COPY --from=builder /app/.build/release/*.so* /usr/local/lib/
COPY --from=builder /app/.build/release/*.swiftmodule /usr/local/lib/

# Update library cache
RUN ldconfig

# Switch to non-root user
USER speedrun

# Set the entrypoint
ENTRYPOINT ["speedrun-cli"]