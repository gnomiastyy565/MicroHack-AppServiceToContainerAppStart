# Base image (runtime)
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["MicroHackApp.csproj", "./"]
RUN dotnet restore "./MicroHackApp.csproj"
COPY . .
RUN dotnet publish "./MicroHackApp.csproj" -c Release -o /app/publish

# Final image
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MicroHackApp.dll"]
