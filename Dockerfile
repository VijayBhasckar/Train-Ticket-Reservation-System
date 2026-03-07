# ---------- Stage 1 : Build the application ----------
FROM maven:3.9.9-eclipse-temurin-17-alpine AS builder

WORKDIR /app

# Copy pom.xml first (better caching)
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the WAR/JAR
RUN mvn clean package -DskipTests


# ---------- Stage 2 : Runtime Image ----------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy built artifact from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java","-jar","app.jar"]
