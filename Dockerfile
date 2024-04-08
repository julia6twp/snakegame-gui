FROM snakepy
LABEL authors="Julia"

WORKDIR /app/snakegame-gui

CMD ["pytest", "-s", "-v"]