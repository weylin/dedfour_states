# dedfour

These are configuration states for some various things I run.

Generally I am running Ubuntu 22.04.2 LTS for all servers, with a mix of AWS EC2 instances and Virtual Private servers at a cloud provider.

SaltStack is running at version 3006.1.

## Development Environment Setup

This project uses Docker to create a complete Salt master-minion development environment.

### Prerequisites
- Docker daemon running
- Salt-call installed on host (for Docker integration)

### Quick Start
1. Clone repository:
   ```bash
   git clone <repository-url>
   cd dedfour_salt_states
   ```

2. Run the automated setup script:
   ```bash
   ./setup-salt-docker.sh
   ```

This will automatically:
- Build custom Salt-enabled Docker images
- Create two Docker containers (salt-master and salt-minion-bots)
- Install SaltStack 3006.1 via Ubuntu repositories
- Deploy pre-configured Salt keys and master/minion configurations
- Start Salt services and establish master-minion communication
- Verify connectivity with test.ping

### Container Architecture
- **salt-master** (Docker network IP): Salt master server with master and minion roles
- **salt-minion-bots**: Salt minion with bots role

### Verification
After setup completes, you can verify:
```bash
# Check master status
docker exec salt-master salt '*' test.ping

# Check minion status  
docker exec salt-minion-bots salt-call test.ping
```

## Troubleshooting

If Docker setup fails:
1. Ensure Docker daemon is running
2. Check that ports 4505/4506 are available
3. Run `docker rm -f salt-master salt-minion-bots` and retry setup
4. Check container logs: `docker logs salt-master` or `docker logs salt-minion-bots`

## Manual Steps No Longer Required

The following manual steps have been automated:
- Salt package installation via wget
- Key generation and distribution
- Master/minion configuration deployment
- Service startup and key acceptance
- Network configuration and host entries
