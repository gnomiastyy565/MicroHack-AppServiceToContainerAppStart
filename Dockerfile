# Base image (runtime)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Skopiuj tylko plik projektu i zrób restore
COPY ["MicroHackApp.csproj", "./"]
RUN dotnet restore "./MicroHackApp.csproj"

# Skopiuj resztę plików i opublikuj aplikację
COPY . .
RUN dotnet publish "./MicroHackApp.csproj" -c Release -o /app/publish

# Final image
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MicroHackApp.dll"]
