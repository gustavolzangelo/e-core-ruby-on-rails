# Project Name
## Overview
This project is a Role Management Service that interacts with an external API to manage users, teams, and their associated roles. The service provides endpoints for creating roles, assigning roles to team members, and querying memberships.
Endpoints
### 1. Create a New Role
•	**Method**: POST
•	**URL**: /roles
•	**Description**: Creates a new role in the system.
•	**Request Body**:
```json
{
  "name": "Developer"
}
```
•	**Response**:
Success: 201 Created

```json
{
  "success": true,
  "role": {
    "id": 1,
    "name": "Developer"
  }
}
```
- **Failure**: 422 Unprocessable Entity

```json
{
  "success": false,
  "errors": ["Role already exists"]
}

```

### 2. Assign a Role to a Team Member
•	**Method**: POST
•	**URL**: /memberships
•	**Description**: Assigns a role to a team member based on user and team IDs.
•	**Request Body:**

```json
{
  "role_name": "Developer",
  "user_id": "fd282131-d8aa-4819-b0c8-d9e0bfb1b75c",
  "team_id": "7676a4bf-adfe-415c-941b-1739af07039b"
}

```
•	**Response**:
Success: 201 Created

```json
{
  "success": true,
  "membership": {
    "user_id": "fd282131-d8aa-4819-b0c8-d9e0bfb1b75c",
    "team_id": "7676a4bf-adfe-415c-941b-1739af07039b",
    "role_id": 1
  }
}

```
**Failure**: 422 Unprocessable Entity

```json
{
  "success": false,
  "errors": ["User not found", "Team not found", "User doesn't belong to the team", "Role not found"]
}

```
### 3. Look Up a Role for a Membership
•	**Method**: GET
•	**URL**: /memberships/:id/role
•	**Description**: Returns the role associated with a specific membership.
•	**Response**:

**Success**: 200 OK

```json
{
  "role": {
    "id": 1,
    "name": "Developer"
  }
}

```
**Failure**: 404 Not Found

```json
{
  "error": "Membership not found"
}
```

**4. Look Up Memberships for a Role**
•	**Method**: GET
•	**URL**: /roles/:id/memberships
•	**Description**: Returns all memberships associated with a specific role.
•	**Response**:

Success: 200 OK

```json
[
  {
    "id": 1,
    "user_id": "fd282131-d8aa-4819-b0c8-d9e0bfb1b75c",
    "team_id": "7676a4bf-adfe-415c-941b-1739af07039b",
    "role_id": 1
  },
  {
    "id": 2,
    "user_id": "fd282132-d8aa-4819-b0c8-d9e0bfb1b76d",
    "team_id": "7676a4bf-adfe-415c-941b-1739af07039b",
    "role_id": 1
  }
]
```

**Failure**: 404 Not Found

```json
{
  "error": "Role not found"
}

```
### Environment Setup
#### .env Setup
To configure the application, you'll need to create a .env file at the root of the project. The .env file contains necessary environment variables to interact with the external API and others.
Copy the following into your .env file and replace with appropriate values.

### Running with Docker

#### 1. Build the Docker Images
```bash
docker-compose build
```
#### 2. Run the Containers
```bash
docker-compose up
```
#### Running Tests
You can run the test suite inside the Docker container using the following command:
```bash
rspec
```
#### Stopping the Application
To stop the application and shut down the containers, run:
```bash
docker-compose down
```

