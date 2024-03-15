# Tech Support Analyst Challenge

This project is a Ruby API REST application using the Grape framework and Sequel ORM. It was created as part of the Solvento Challenge for the Tech Support Analyst position.

## Requirements

To run this project, you need to have Docker installed on your system.

## Getting Started

Follow these steps to get the project up and running:

1. Pull the Docker image from the Docker Hub:

```bash
docker pull alexjsk88/tech-support-analyst-challenge:v0.1

- Once the Docker image is pulled, you can start the application. Open a web browser and navigate by the URLs according to API endpoints.

## API Endpoints

### Health Check

- `GET /api/v1/health`: Test API working status.

### Trucks

- `GET /api/v1/trucks`: Get trucks list.
- `GET /api/v1/trucks/available`: Get available trucks list.
- `POST /api/v1/trucks`: Add a new truck to the fleet. The truck is_available property is true by default. Requires `plate_number` (String) and `max_weight_capacity` (BigDecimal). Optional `work_days` (String), default is 'Monday'.
- `DELETE /api/v1/trucks`: Remove a truck from the fleet just if their trip is pending or delivered. Either `truck_id` (Integer) or `plate_number` (String) is required.
- `GET /api/v1/trucks/schedule`: Schedule trucks for delivery trips using a date for scheduling as param. Requires `date` (DateTime).

### Trips

- `GET /api/v1/trips`: Get trips list.
- `GET /api/v1/trips/schedule`: Schedule delivery trips using a date for scheduling as param. Requires `date` (DateTime).



