from __future__ import annotations

from fastapi import FastAPI

from core.config.settings import settings
from core.logging.logger import configure_logging


def create_app() -> FastAPI:
    configure_logging()
    return FastAPI(
        title=settings.app_name,
        version=settings.app_version,
        description="MentorinAja backend bootstrap",
        debug=settings.debug,
    )


app = create_app()


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=settings.debug)
