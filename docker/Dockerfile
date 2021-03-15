############################################################
# Dockerfile that contains SteamCMD
############################################################
FROM debian:buster-slim

ARG PUID=1000
ARG A_SERVER_NAME="Dante's Server"
ARG A_WORLD_NAME="genesis"
ARG A_PASSWORD="secret"

COPY valheim-start.sh .

ENV USER steam
ENV HOMEDIR "/home/${USER}"
ENV STEAMCMDDIR "${HOMEDIR}/steamcmd"
ENV VAILHEIM_PATH ${HOMEDIR}/valheim-dedicated
ENV WORLDS_PATH ${HOMEDIR}/.config/unity3d/IronGate/Valheim/worlds
ENV SERVER_NAME=${A_SERVER_NAME}
ENV WORLD_NAME=${A_WORLD_NAME}
ENV PASSWORD=${A_PASSWORD}

# Install, update & upgrade packages
# Create user for the server
# This also creates the home directory we later need
# Clean TMP, apt-get cache and other stuff to make the image smaller
# Create Directory for SteamCMD
# Download SteamCMD
# Extract and delete archive
RUN set -x \
	&& dpkg --add-architecture i386 \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6=8.3.0-6 \
		lib32gcc1=1:8.3.0-6 \
		wget=1.20.1-1.1 \
		ca-certificates=20200601~deb10u2 \
		nano=3.2-3 \
		libsdl2-2.0-0:i386=2.0.9+dfsg1-1 \
		curl=7.64.0-4+deb10u1 \
		locales=2.28-10 \
	&& sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& dpkg-reconfigure --frontend=noninteractive locales \
	&& useradd -u "${PUID}" -m "${USER}" \
        && su "${USER}" -c \
                "mkdir -p \"${STEAMCMDDIR}\" \"${WORLDS_PATH}\" \
                && wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C \"${STEAMCMDDIR}\" \
                && \"./${STEAMCMDDIR}/steamcmd.sh\" +quit \
                && mkdir -p \"${HOMEDIR}/.steam/sdk32\" \
                && ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${HOMEDIR}/.steam/sdk32/steamclient.so\" \
		&& ln -s \"${STEAMCMDDIR}/linux32/steamcmd\" \"${STEAMCMDDIR}/linux32/steam\" \
		&& ln -s \"${STEAMCMDDIR}/steamcmd.sh\" \"${STEAMCMDDIR}/steam.sh\"" \
	&& ln -s "${STEAMCMDDIR}/linux32/steamclient.so" "/usr/lib/i386-linux-gnu/steamclient.so" \
	&& ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" \
    && ${STEAMCMDDIR}/steamcmd.sh +login anonymous +force_install_dir ${VAILHEIM_PATH} +app_update 896660 +quit \
    && mv valheim-start.sh ${VAILHEIM_PATH} \
    && chmod +x ${VAILHEIM_PATH}/valheim-start.sh && chown ${USER} ${VAILHEIM_PATH}/valheim-start.sh \
	&& apt-get remove --purge -y \
		wget \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

 

# Switch to user
USER ${USER}

WORKDIR ${VAILHEIM_PATH}

VOLUME ${STEAMCMDDIR}
VOLUME ${WORLDS_PATH}

EXPOSE 2456 2457

ENTRYPOINT ["sh", "./valheim-start.sh"]
CMD ["bash", "-c"]
