# This Dockerfile sets up an Alpine Linux environment with XFCE, TigerVNC, and noVNC for web-based VNC access.
# It includes a client-side WebSocket script (/opt/noVNC/script.js) for handling data received from the server.
# The VNC server runs on port 5999, and noVNC is configured to connect to it.

# Use the latest Alpine Linux as the base image
FROM alpine:latest

LABEL maintainer="Zimiat (yason.pr@gmail.com)"

# Install necessary packages and dependencies
RUN apk add --no-cache sudo git xfce4 faenza-icon-theme bash python3 tigervnc xfce4-terminal firefox cmake wget nodejs npm build-base \
    && adduser -h /home/alpine -s /bin/bash -S -D alpine \
    && echo -e "alpine\nalpine" | passwd alpine \
    && echo 'alpine ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && git clone https://github.com/novnc/noVNC /opt/noVNC \
    && git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify

# Configure the client-side script for WebSocket connection
RUN echo 'window.onload = function () {' \
        '   var socketURL = "ws://" + window.location.hostname + ":56780";' \
        '   var ws = new WebSocket(socketURL);' \
        '   ws.binaryType = "arraybuffer";' \
        '   ws.addEventListener("message", function (event) {' \
        '       // Handle the received data here if needed' \
        '   });' \
        '};' > /opt/noVNC/script.js

# Install WebSocket library for Node.js
RUN npm install --prefix /opt/noVNC ws

# Switch to the non-root user and set the working directory
USER alpine
WORKDIR /home/alpine

# Configure VNC settings
RUN mkdir -p /home/alpine/.vnc \
    && echo -e "-Securitytypes=none" > /home/alpine/.vnc/config \
    && echo -e "#!/bin/bash\nstartxfce4 &" > /home/alpine/.vnc/xstartup \
    && echo -e "alpine\nalpine\nn\n" | vncpasswd

# Switch back to the root user for the final setup
USER root

# Configure entry script for running VNC server and noVNC proxy
RUN echo '\
#!/bin/bash \
/usr/bin/vncserver :99 2>&1 | sed  "s/^/[Xtigervnc ] /" & \
sleep 1 & \
/opt/noVNC/utils/novnc_proxy --vnc localhost:5999 2>&1 | sed "s/^/[noVNC     ] /"'\
>/entry.sh

# Switch back to the non-root user for container execution
USER alpine

# Set the entry point for the container
ENTRYPOINT [ "/bin/bash", "/entry.sh" ]