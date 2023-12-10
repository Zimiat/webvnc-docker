# Use the latest Alpine Linux as the base image
FROM alpine:latest

LABEL maintainer="Zimiat (yason.pr@gmail.com)"

# Install necessary packages and dependencies:
RUN apk add --no-cache \
    sudo git xfce4 faenza-icon-theme bash python3 tigervnc xfce4-terminal firefox cmake wget nodejs npm build-base \
    \
    # Create a non-root user 'alpine' with a home directory and set /bin/bash as the shell:
    && adduser -h /home/alpine -s /bin/bash -S -D alpine \
    \
    # Set the password for the 'alpine' user to 'alpine':
    && echo -e "alpine\nalpine" | passwd alpine \
    \
    # Allow the 'alpine' user to execute sudo commands without entering a password:
    && echo 'alpine ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    \
    # Clone the noVNC and websockify repositories from GitHub into /opt/noVNC:
    && git clone https://github.com/novnc/noVNC /opt/noVNC \
    && git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify \
    \
    # Install the 'ws' WebSocket library for Node.js in the /opt/noVNC directory:
    && npm install --prefix /opt/noVNC ws \
    \
    # Create a client-side script (/opt/noVNC/script.js) for handling WebSocket connection:
    && echo 'window.onload = function () {' \
        '   var socketURL = "ws://" + window.location.hostname + ":56780";' \
        '   var ws = new WebSocket(socketURL);' \
        '   ws.binaryType = "arraybuffer";' \
        '   ws.addEventListener("message", function (event) {' \
        '       // Handle the received data here if needed' \
        '   });' \
        '};' > /opt/noVNC/script.js \
    \
    # Create a directory for VNC configurations and set up initial configuration files:
    && mkdir -p /home/alpine/.vnc \
    && echo -e "-Securitytypes=none" > /home/alpine/.vnc/config \
    && echo -e "#!/bin/bash\nstartxfce4 &" > /home/alpine/.vnc/xstartup \
    \
    # Set the VNC password for the 'alpine' user:
    && echo -e "alpine\nalpine\nn\n" | vncpasswd \
    \
    # Create an entry script (/entry.sh) for running VNC server and noVNC proxy:
    && echo '\
        #!/bin/bash \
        /usr/bin/vncserver :99 2>&1 | sed  "s/^/[Xtigervnc ] /" & \
        sleep 1 & \
        /opt/noVNC/utils/novnc_proxy --vnc localhost:5999 2>&1 | sed "s/^/[noVNC     ] /"'\
        >/entry.sh

# Switch back to the non-root user for container execution
USER alpine

# Set the entry point for the container
ENTRYPOINT [ "/bin/bash", "/entry.sh" ]