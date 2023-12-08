## Docker Container Readme

### Overview

This Dockerfile sets up an Alpine Linux environment with XFCE, TigerVNC, and noVNC for web-based VNC access. Users can connect to a graphical desktop environment through a web browser, making it ideal for remote desktop applications.

### Features

- **Alpine Linux Base Image**: Utilizes the lightweight Alpine Linux distribution to keep the container size minimal.

- **XFCE Desktop Environment**: Includes the XFCE desktop environment for a user-friendly interface.

- **TigerVNC**: Installs TigerVNC as the VNC server, enabling users to access the desktop environment remotely.

- **noVNC**: Integrates noVNC for web-based VNC access, allowing users to connect to the desktop environment directly from a web browser.

- **WebSocket Connection**: Establishes a WebSocket connection between the server and client for efficient data communication.

- **WebSocketify**: Utilizes the WebSocketify utility to facilitate WebSocket connections between the VNC server and the noVNC client.

- **Node.js and npm**: Installs Node.js and npm for managing JavaScript dependencies, specifically required for WebSocket communication.

### Usage

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/Zimiat/webvnc-docker.git
   cd your-repo
   ```

2. **Build the Docker Image:**
   ```bash
   docker build -t webvnc .
   ```

3. **Run the Docker Container:**
   ```bash
   docker run --rm -p 5900:5999 -p 6080:6080 webvnc
   ```

   - Port 5900 for VNC access.
   - Port 6080 for noVNC web-based access.

   **Join Through Regular VNC:**
   Connect using a regular VNC client to `localhost:5900`.

4. **Access the Desktop Environment:**
   Open a web browser and navigate to `http://localhost:6080/vnc.html`. Interact with the XFCE desktop environment through the web interface.

5. **Docker Compose:**
   Use the following `docker-compose.yml` file for simplified deployment:

   ```yaml
   version: '3'
   services:
     webvnc:
       image: webvnc
       ports:
         - "5900:5999"
         - "6080:6080"
   ```

   Run with:
   ```bash
   docker-compose up -d
   ```

### Customization

- **VNC Password:**
  - The default VNC password is set to "alpine." Modify the relevant section in the Dockerfile for password customization.

- **Additional Software:**
  - Extend the Dockerfile to include additional software or packages based on specific requirements.

### Security Considerations

- VNC access currently uses no authentication (`-Securitytypes=none`). Implement secure practices based on your deployment environment.

- Exercise caution when deploying the container in production, ensuring adequate security measures are in place.

## Acknowledgments

- noVNC: [https://github.com/novnc/noVNC](https://github.com/novnc/noVNC)
- TigerVNC: [https://github.com/TigerVNC/tigervnc](https://github.com/TigerVNC/tigervnc)

### License

This Dockerfile is provided under the [MIT License](LICENSE). Modify and distribute it according to your needs.
