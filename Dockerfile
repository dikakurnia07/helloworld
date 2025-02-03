# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the local jar to the container
COPY target/helloworld-0.0.1-SNAPSHOT.jar helloworld.jar

# Run the jar file
ENTRYPOINT ["java", "-jar", "helloworld.jar"]

# Expose the port on which your application will run
EXPOSE 8080
