# Use the latest Debian base image
FROM debian:latest

# Set environment variables to avoid prompts during installations
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y git python3 python3-pip build-essential cmake clang sudo && \
    apt-get clean

# Clone the GoblinWordGenerator repository
RUN git clone https://github.com/UndeadSec/GoblinWordGenerator.git /GoblinWordGenerator

# Install ttyd from the source
RUN git clone --recurse-submodules https://github.com/tsl0922/ttyd.git /ttyd && \
    cd /ttyd && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install

# Create a start script to run ttyd with bash
RUN echo '#!/bin/bash\n\
# Start ttyd and execute the goblin.py script within it\n\
ttyd --writable bash -c "python3 /GoblinWordGenerator/goblin.py; exec bash"' > /start.sh && \
    chmod +x /start.sh

# Expose the port ttyd will run on (default is 7681)
EXPOSE 7681

# Set the start script as the CMD entry point
CMD ["/start.sh"]
